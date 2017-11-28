require 'erb'
require 'json'
require 'net/http'
require 'uri'


module MiPush
  $MAX_BACKOFF_DELAY = 1024000
  include Constants
  include ERB::Util

  def _build_request_url(server, request_path)
    return Constants.http_protocol + "://" + server.host + request_path[0]
  end


  def encode_params(params)
    qstring = ''
    params.each do |key, value|
      if qstring.empty?
        qstring += "#{key}=#{value}"
      else
        qstring += "&#{key}=#{value}"
      end
    end
    return qstring
  end

  def http_call(url, method, authorization, token, params, proxy_ip, proxy_port)
    query = ERB.Util.encode_www_form(encode_params(params))
    header = {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'}
    if authorization
      header['Authorization'] = 'key=%s' % authorization
    end
    if token
      header['X-PUSH-AUDIT-TOKEN'] = token
    end
    if Constants::auto_switch_host and ServerSwitch().need_refresh_host_list()
      header['X-PUSH-HOST_LIST'] = 'true'
    end

    begin
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port, proxy_ip, proxy_port)
      if method == Constants::HTTP_POST
        req = Net::HTTP::Post.new(uri.request_uri, header)
        req.body = query
      else
        uri.query = query
        req = Net::HTTP::GET.new(uri.request_uri, header)
      end
      response = http.request(req)

      host_list = response.header['x-push-host-list']
      if host_list
        ServerSwitch().update(host_list)
      end
      r = JSON.parse(response.body)
      if r['code'] != 0
          raise APIError(r['code'], r['description'], r['reason'])
      end
      return r
    rescue => e
      raise APIError('-5', e, 'http_error')
    end
  end

  class Base

    def initialize(security, token=nil)
      @security = security
      @token = token
      @proxy_ip = nil
      @proxy_port = nil
      @proxy = false
    end

    def set_proxy(proxy_ip, proxy_port)
      @proxy_ip = proxy_ip
      @proxy_port = proxy_port
      @proxy = true
    end

    def set_token(token)
      @token = token
    end

    def call_request(request_path, method, params)
      start = Time.now.to_f
      server = ServerSwitch().select_server(request_path)
      request_url = _build_request_url(server, request_path)
      begin
        ret = http_call(request_url, method, @security, @token, params,
                       proxy_ip, proxy_port)
        if Time.now.to_f - start > 5
          server.decr_priority
        else
          server.incr_priority
        end
      rescue => e
        server.decr_priority
        raise e
      end
    end

    def http_post(request_path, params)
      return self.call_request(request_path, Constants::HTTP_POST, params)
    end

    def http_get(request_path, params)
      return self.call_request(request_path, Constants::HTTP_GET, params)
    end

    def try_http_request(request_path, retry_times, method=Constants::HTTP_POST, params)
      is_fail, try_time, result, sleep_time = true, 0, nil, 1
      while is_fail and try_time < retry_times
        begin
          if method == Constants::HTTP_POST
            result = self.http_post(request_path, params)
          elsif method == Constants::HTTP_GET
            result = self.http_get(request_path, params)
          else
            raise APIError('-2', 'not support %s http reqeust' % method, 'http error')
          end
          is_fail = false
        rescue => e
          if e.error_code == '-5'
            is_fail = true
          end
          try_time += 1
          sleep(sleep_time)
          if sleep_time * 2 < $MAX_BACKOFF_DELAY
            sleep_time *= 2
          end
        end
      end
      if not result
        raise APIError('-3', 'retry %s time failure' % retry_times, 'request error')
      end
      return result
    end
  end
end
