# -*- coding:utf-8 -*-


class APIError < StandardError

  def initialize(error_code, error, request)
    @message = 'APIError: %s: %s, request: %s' % [error_code, error, request]
    super(@message)
  end

end
