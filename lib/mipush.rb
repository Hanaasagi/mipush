require "./mipush/api_error"
require "./mipush/api_hostswitch"
require "./mipush/api_message"
require "./mipush/api_senderbase"
require "./mipush/constants"
require "./mipush/api_senderbase"

module MiPush

  BROADCAST_TOPIC_MAX = 5
  TOPIC_SPLITTER = ';$;'

  # 发送消息API(send push message class)
  # 构造方法接收两个参数:
  # @:param security 必须 - APP_SECRET
  # @:param token 可选 - 发送topic消息数超过1w所需要的验证token, 需到push运营平台申请
  class APISender < Base


    # 发送reg_id消息
    # :param push_message: 消息体(请求参数对象)
    # :param reg_id: reg_id(多个reg_id - list)
    # :param retry_times: 重试次数
    def send(push_message, reg_id, retry_times=3)
      push_message[Constants::http_param_registration_id] = reg_id
      return self.try_http_request(Constants::request_path[:V3_REGID_MESSAGE],
                                   retry_times, push_message)
    end

    # 发送alias消息
    # :param push_message: 消息体(请求参数对象)
    # :param alias: alias(多个alias - list)
    # :param retry_times: 重试次数
    def send_to_alias(push_message, alias_msg, retry_times=3)
      push_message[Constants::http_param_alias] = alias_msg
      return self.try_http_request(Constants::request_path[:V3_ALIAS_MESSAGE],
                                  retry_times, push_message)
    end

    # 发送user_account消息
    # :param push_message: 消息体(请求参数对象)
    # :param user_account: user_account(多个user_account - list)
    # :param retry_times: 重试次数
    def send_to_user_account(push_message, user_account, retry_times=3)
      push_message[Constants::http_param_user_account] = user_account
      return self.try_http_request(Constants::request_path[:V2_USER_ACCOUNT_MESSAGE],
                                  retry_times, push_message)
    end

    # 发送topic消息(single)
    # :param push_message: 消息体(请求参数对象)
    # :param topic: topic(只支持单个)
    # :param retry_times: 重试次数
    def broadcast(push_message, topic, retry_times=3)
      push_message[Constants::http_param_topic] = topic
      return self.try_http_request(Constants::request_path[:V2_BROADCAST],
                                   retry_times, push_message)
    end

    # 发送全量广播
    # :param push_message: 消息体(请求参数对象)
    # :param retry_times: 重试次数
    def broadcast_all(push_message, retry_times=3)
      package_names = push_message[Constants::http_param_restricted_package_name]
      request_path = Constants::request_path[:V2_BROADCAST_TO_ALL]
      if package_names.length > 1
        request_path = Constants::request_path[:V3_BROADCAST_TO_ALL]
      end
      return self.try_http_request(request_path, retry_times, push_message)
    end

    # 发送多topic消息(multi)
    # :param push_message: 消息体(请求参数对象)
    # :param topics: topic集合(list)
    # :param broadcast_topic_op: topic类型[交集, 并集, 差集]
    # :param retry_times: 重试次数
    def multi_broadcast(push_message, topics, broadcast_topic_op, retry_times=3)
      if topics.is_a? Array
        if topics.length > BROADCAST_TOPIC_MAX
          raise APIError(-1, 'topics more than max topic 5', 'args limit')
        end
        push_message[Constants::http_param_topics] = topics.join(TOPIC_SPLITTER)
        push_message[Constants::http_param_topic_op] = broadcast_topic_op
        return self.try_http_request(Constants::request_path[:V3_MILTI_TOPIC_BROADCAST],
                                    retry_times, push_message)
      else
        raise APIError(-1, 'topic must be list', 'args illegal')
      end
    end
  end
end

