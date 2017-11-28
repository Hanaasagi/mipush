# -*- coding:utf-8 -*-

require 'singleton'
require 'thread'

module MiPush

  mutex = Mutex.new


  class Server
    # 服务model(包含host, 最小权重, 最大权重, 权重速率)

    private :change_priority

    def initialize(host, min_priority, max_priority, decr_step, incr_step)
      @host = host
      @priority = max_priority
      @min_priority = min_priority
      @max_priority = max_priority
      @decr_step = decr_step
      @incr_step = incr_step
    end

    def incr_priority
      change_priority true
    end

    def decr_priority
      change_priority false
    end

    def change_priority(is_incr)
      mutex.lock

      if is_incr
        change_priority = @priority + @incr_step
      else
        change_priority = @priority - @decr_step
      end

      if change_priority < @min_priority
        change_priority = @min_priority
      elsif change_priority > @max_priority
        change_priority = @max_priority
      end

      @priority = change_priority

      mutex.unlock
    end
  end


  class ServerSwitch
    # 服务host选举类(单例)
    # 加权轮询算法
    include Singleton
    private :select_server

    def initialize
      @feedback = Server.new(Constants.host_production_feedback, 100, 100, 0, 0)
      @sandbox = Server.new(Constants.host_sandbox, 100, 100, 0, 0)
      @specified = Server.new(Constants.host, 100, 100, 0, 0)
      @emq = Server.new(Constants.host_emq, 100, 100, 0, 0)
      @default_server = Server.new(Constants.host_production, 1, 90, 10, 5)
      @servers = []
      @inited = false
      @last_refresh_time = Time.now.to_f
    end

    def need_refresh_host_list
      not @inited or(Time.now.to_f - @last_refresh_time) >= Constants.refresh_server_host_interval
    end

    def update(host_list)
      if not self.need_refresh_host_list
        return
      end
      vs = host_list.split(',')
      for s in vs
        sp = s.split(':')
        if sp.length < 5
          @servers.push(@default_server)
          next
        end
        @servers.push(Server(sp[0], sp[1].to_i, sp[2].to_i, sp[3].to_i, sp[4].to_i))

        @inited = true
        @last_refresh_time = Time.now.to_f
      end
    end

    def select_server(request_path)
      if Constants.host
          return @specified
      end

      if Constants.is_sandbox
          return @sandbox
      end

      if request_path.length == 2
        if request_path[1] == 2
            return @feedback
        end
        if request_path[1] == 3
            return @emq
        end
        return select_server
      end
      return select_server
    end

    def select_server
      if not Constants.auto_switch_host
          return @default_server
      end

      priority_list = @servers.map do |server|
        server.priority
      end

      all_priority = priority_list.sum

      random_point = Random.new.rand(0..all_priority)

      priority_sum = 0
      priority_list.each_with_index do |priority, index|
        priority_sum += priority
        if random_point <= priority_sum
          return @servers[index]
        end
      end
      return @default_server
    end
  end
end
