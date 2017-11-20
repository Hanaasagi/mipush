# -*- coding:utf-8 -*-


module Mipush

  module Constants

    VERSION = '1.0.3'
    HTTP_GET = 0
    HTTP_POST = 1

    METHOD_MAP = {
      'GET'=> HTTP_GET,
      'POST'=> HTTP_POST
    }

    sdk_version        = "RUBY_SDK_V1.0.3"
    max_message_length = 140
    auto_switch_host   = true
    access_timeout     = 5000
    http_protocol      = "https"

    # 相关 Push 域名定义
    host_emq                 = "emq.xmpush.xiaomi.com"
    host_sandbox             = "sandbox.xmpush.xiaomi.com"
    host_production          = "api.xmpush.xiaomi.com"
    host_production_lg       = "lg.api.xmpush.xiaomi.com"
    host_production_c3       = "c3.api.xmpush.xiaomi.com"
    host_production_feedback = "feedback.xmpush.xiaomi.com"
    host                     = nil

    is_sandbox = false
    refresh_server_host_interval = 300 # 5 * 60

    # HTTP parameter name
    http_param = {
      :registration_id             => "registration_id",
      :collapse_key                => "collapse_key",
      :job_key                     => "jobkey",
      :payload                     => "payload",
      :topic                       => "topic",
      :alias                       => "alias",
      :aliases                     => "aliases",
      :user_account                => "user_account",
      :title                       => "title",
      :description                 => "description",
      :notify_type                 => "notify_type",
      :notify_id                   => "notify_id",
      :time_to_send                => "time_to_send",
      :url                         => "url",
      :pass_through                => "pass_through",
      :messages                    => "messages",
      :extra_prefix                => "extra.",
      :aps_prefix                  => "aps_proper_fields.",
      :aps_title                   => "title",
      :aps_subtitle                => "subtitle",
      :aps_body                    => "body",
      :aps_mutable_content         => "mutable-content",
      :category                    => "category",
      :job_id                      => "job_id",
      :topics                      => "topics",
      :topic_op                    => "topic_op",
      :app_id                      => "app_id",
      :start_ts                    => "start_time",
      :end_ts                      => "end_time",
      :job_type                    => "type",
      :max_count                   => "max_count",

      :delay_while_idle            => "delay_while_idle",
      :dry_run                     => "dry_run",
      :restricted_package_name     => "restricted_package_name",
      :payload_prefix              => "data.",
      :time_to_live                => "time_to_live",

      :error_quota_exceeded        => "QuotaExceeded",
      :error_device_quota_exceeded => "QuotaExceeded",
      :error_missing_registration  => "MissingRegistration",
      :error_invalid_registration  => "InvalidRegistration",
      :error_mismatch_sender_id    => "MismatchSenderId",
      :error_not_registration      => "NotRegistered",
      :error_message_too_big       => "MessageTooBig",
      :error_missing_collapse_key  => "MissingCollapseKey",
      :error_unavailable           => "Unavailable",
      :error_internal_server_error => "InternalServerError",
      :error_invalid_ttl           => "InvalidTtl",

      :token_message_id            => "id",
      :token_canonical_reg_id      => "registration_id",
      :token_error                 =>"Error",

      :registration_ids            => "registration_ids",
      :json_payload                => "data",
      :json_success                => "success",
      :json_failure                => "failure",
      :json_multicast_id           => "multicast_id",
      :json_results                => "results",
      :json_error                  => "error",
      :json_message_id             => "message_id",

      :start_date                  => "start_date",
      :end_date                    => "end_date",
      :trace_begin_time            => "begin_time",
      :trace_end_time              => "end_time",
      :trace_msg_id                => "msg_id",
      :trace_job_key               => "job_key",
    }

    # sound_uri 提供通知栏自定义铃声的URI
    extra_param = {
      :sound_uri                       => "sound_uri",
      :sound_url                       => "sound_url",
      :badge                           => "badge",
      :category                        => "category",
      :flow_control                    => 'flow_control',

      :intent_uri                      => "intent_uri",
      :web_uri                         => "web_uri",
      :notification_ticker             => "ticker",
      :class_name                      => "class_name",
      :intent_flag                     => "intent_flag",
      :ios_msg_channel                 => "ios_msg_channel",
      :ios_msg_channel_apns_only       => "1",
      :ios_msg_channel_connection_only => "2",

      :alert_title                     => "apsAlert-title",
      :alert_body                      => "apsAlert-body",
      :alert_title_loc_key             => "apsAlert-title-loc-key",
      :alert_title_loc_args            => "apsAlert-title-loc-args",
      :alert_action_loc_key            => "apsAlert-action-loc-key",
      :alert_loc_key                   => "apsAlert-loc-key",
      :alert_loc_args                  => "apsAlert-loc-args",
      :alert_launch_image              => "apsAlert-launch-image",
    }

    # notify_effect定义点击通知栏的后续行为, 默认值情况下, 表示向客户端app传递消息, 其他值定义如下:
    # NOTIFY_LAUNCHER_ACTIVITY: 通知栏点击后打开app的Launcher Activity
    # NOTIFY_ACTIVITY: 通知栏点击后打开app的任一组件(开发者需要传入EXTRA_PARAM_INTENT_URI)
    # NOTIFY_WEB: 通知栏点击后打开网页(开发者需要传入EXTRA_PARAM_WEB_URI)
    # 详述请参考:http://dev.xiaomi.com/doc/?p=533
    extra_param[:extra_param_notify_effect] = "notify_effect"
    notify_launcher_activity                = "1"
    notify_activity                         = "2"
    notify_web                              = "3"

    # 如果app在前台, 这时向客户端app发送非透传消息, 可以根据 NOTIFY_FOREGROUND 参数值决定是否弹出通知栏
    # 默认情况下, app会弹出通知栏, 为了不弹出通知栏可以将 NOTIFY_FOREGROUND 设置为"0"
    extra_param[:notify_foreground] = "notify_foreground"


    # Union 并集
    # Intersection 交集
    # Except 差集
    broadcast_topic_op = {
      :Union        => 'UNION',
      :Intersection => 'INTERSECTION',
      :Except       => 'EXCEPT'
    }


    # TARGET_TYPE_REGID regid消息类型
    # TARGET_TYPE_ALIAS alias消息类型
    # TARGET_TYPE_USER_ACCOUNT user-account消息类型
    target_type = {
      :TARGET_TYPE_REGID        => 1,
      :TARGET_TYPE_ALIAS        => 2,
      :TARGET_TYPE_USER_ACCOUNT => 3
    }

    request_type = {
      :Message  => 1,
      :Feedback => 2,
      :Emq      => 3
    }

    subscribe_type = {
      :RegId => 1,
      :Alias => 2,
    }

    request_path = {
      :V2_SEND                            => ["/v2/send"],
      :V2_REGID_MESSAGE                   => ["/v2/message/regid"],
      :V3_REGID_MESSAGE                   => ["/v3/message/regid"],

      :V2_SUBSCRIBE_TOPIC                 => ["/v2/topic/subscribe"],
      :V2_UNSUBSCRIBE_TOPIC               => ["/v2/topic/unsubscribe"],
      :V2_SUBSCRIBE_TOPIC_BY_ALIAS        => ["/v2/topic/subscribe/alias"],
      :V2_UNSUBSCRIBE_TOPIC_BY_ALIAS      => ["/v2/topic/unsubscribe/alias"],

      :V2_ALIAS_MESSAGE                   => ["/v2/message/alias"],
      :V3_ALIAS_MESSAGE                   => ["/v3/message/alias"],

      :V2_BROADCAST_TO_ALL                => ["/v2/message/all"],
      :V3_BROADCAST_TO_ALL                => ["/v3/message/all"],
      :V2_BROADCAST                       => ["/v2/message/topic"],
      :V3_BROADCAST                       => ["/v3/message/topic"],
      :V2_MULTI_TOPIC_BROADCAST           => ["/v2/message/multi_topic"],
      :V3_MILTI_TOPIC_BROADCAST           => ["/v3/message/multi_topic"],
      :V2_DELETE_BROADCAST_MESSAGE        => ["/v2/message/delete"],

      :V2_USER_ACCOUNT_MESSAGE            => ["/v2/message/user_account"],

      :V2_SEND_MULTI_MESSAGE_WITH_REGID   => ["/v2/multi_messages/regids"],
      :V2_SEND_MULTI_MESSAGE_WITH_ALIAS   => ["/v2/multi_messages/aliases"],
      :V2_SEND_MULTI_MESSAGE_WITH_ACCOUNT => ["/v2/multi_messages/user_accounts"],

      :V1_VALIDATE_REGID                  => ["/v1/validation/regids"],
      :V1_GET_ALL_ACCOUNT                 => ["/v1/account/all"],
      :V1_GET_ALL_TOPIC                   => ["/v1/topic/all"],
      :V1_GET_ALL_ALIAS                   => ["/v1/alias/all"],

      :V1_MESSAGES_STATUS                 => ["/v1/trace/messages/status"],
      :V1_MESSAGE_STATUS                  => ["/v1/trace/message/status"],
      :V1_GET_MESSAGE_COUNTERS            => ["/v1/stats/message/counters"],

      :V1_FEEDBACK_INVALID_ALIAS          => ["/v1/feedback/fetch_invalid_aliases", request_type.Feedback],
      :V1_FEEDBACK_INVALID_REGID          => ["/v1/feedback/fetch_invalid_regids", request_type.Feedback],

      :V1_REGID_PRESENCE                  => ["/v1/regid/presence"],
      :V2_REGID_PRESENCE                  => ["/v1/regid/presence"],

      :V2_DELETE_SCHEDULE_JOB             => ["/v2/schedule_job/delete"],
      :V3_DELETE_SCHEDULE_JOB             => ["/v3/schedule_job/delete"],
      :V2_CHECK_SCHEDULE_JOB_EXIST        => ["/v2/schedule_job/exist"],
      :V2_QUERY_SCHEDULE_JOB              => ["/v2/schedule_job/query"],

      :V1_EMQ_ACK_INFO                    => ["/msg/ack/info", request_type.Emq],
      :V1_EMQ_CLICK_INFO                  => ["/msg/click/info", request_type.Emq],
      :V1_EMQ_INVALID_REGID               => ["/app/invalid/regid", request_type.Emq],
    }
  end

end
