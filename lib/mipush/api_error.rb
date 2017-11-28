# -*- coding:utf-8 -*-


module MiPush

  class APIError < StandardError

    def initialize(error_code, error, request)
      @message = 'APIError: %s: %s, request: %s' % [error_code, error, request]
      super(@message)
    end

  end

end
