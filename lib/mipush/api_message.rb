module MiPush

  class PushTargetMessage
    def initialize(push_message, target_type, target)
      @push_message = push_message
      @target_type = target_type
      @target = target
    end
  end


  class PushMessage

    def initialize()
      @message_dict = {}
    end

    def collapse_key(collapse_key)
      @message_dict[Constants::http_param[:collapse_key]] = collapse_key
      return self
    end

    def payload(payload)
      @message_dict[Constants::http_param[:payload]] = payload
      return self
    end

    def title(title)
      @message_dict[Constants::http_param[:title]] = title
      return self
    end

    def description(description)
      @message_dict[Constants::http_param[:description]] = description
      return self
    end

    def notify_type(notify_type)
      @message_dict[Constants::http_param[:notify_type]] = notify_type
      return self
    end

    def time_to_live(time_to_live)
      @message_dict[Constants::http_param[:time_to_live]] = time_to_live
      return self
    end

    def restricted_package_name(package_name)
      @message_dict[Constants::http_param[:restricted_package_name]] = [package_name]
      return self
    end

    def restricted_package_names(package_name)
      @message_dict[Constants::http_param[:restricted_package_name]] = package_name
      return self
    end


    def pass_through(pass_through=0)
      @message_dict[Constants.http_param[:pass_through]] = pass_through
      return self
    end

    def notify_id(notify_id=0)
      @message_dict[Constants.http_param[:notify_id]] = notify_id
      return self
    end

    def extra(extra)
      extra.items{ |k, v|
          @message_dict['%s%s' % [Constants.http_param[:extra_prefix], k]] = v
      }
      return self
    end

    def extra_element(key, value)
      @message_dict['%s%s' % [Constants.http_param[:extra_prefix], key]] = value
      return self
    end

    # aps特殊字段适配
    def aps_element(key, value)
        @message_dict['%s%s' % [Constants.http_param[:aps_prefix], key]] = value
        return self
    end

    def aps_title(value)
      self.aps_element(Constants.http_param[:aps_title], value)
      return self
    end

    def aps_subtitle(value)
      self.aps_element(Constants.http_param[:aps_subtitle], value)
      return self
    end

    def aps_body(value)
      self.aps_element(Constants.http_param[:aps_body], value)
      return self
    end

    def aps_mutable_content(value)
      self.aps_element(Constants.http_param[:aps_mutable_content], value)
      return self
    end

    # 平滑推送, 目前仅对android消息有效
    def enable_flow_control()
      self.extra_element(Constants.extra_param[:flow_control], '1')
      return self
    end

    # 定时发送消息, timeToSend是用自1970年1月1日以来00:00:00.0UTC时间表示（以毫秒为单位的时间）
    # 注：仅支持七天内的定时消息
    def time_to_send(time_to_send)
      @message_dict[Constants.http_param[:time_to_send]] = time_to_send
      return self
    end

    # ios自定义通知数字角标
    def badge(badge)
      self.extra_element(Constants.extra_param[:badge], badge)
      return self
    end

    # ios8推送消息快速回复类别
    def category(category)
      self.extra_element(Constants.extra_param[:category], category)
      return self
    end

    # ios设置通知铃声
    def sound_url(sound_url)
      self.extra_element(Constants.extra_param[:sound_url], sound_url)
      return self
    end

    # ios设置苹果apns通道
    def apns_only()
      self.extra_element(Constants.extra_param[:ios_msg_channel],
                         Constants.extra_param[:ios_msg_channel_apns_only])
      return self
    end

    # ios设置长连接通道
    def connection_only()
      self.extra_element(Constants.extra_param[:ios_msg_channel],
                         Constants.extra_param[:ios_msg_channel_connection_only])
      return self
    end

    # android message params build method
    # need verify package_name must be not null
    def message_dict()
      if @message_dict[Constants.http_param[:restricted_package_name]] then
        return nil
      end
      return @message_dict
    end

    # ios message params build method
    def message_dict_ios()
       return @message_dict
    end

  end
end
