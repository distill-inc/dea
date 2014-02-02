module Dea
  class ExchangeApiError < StandardError
    attr_accessor :code, :body, :message
    def initialize(response)
      @code = response.code
      begin
        @body = JSON.load(response.body) || {}
      rescue JSON::ParserError
        raise UnparseableApiError.new(response)
      end
      @message = {
        subject: @body['Message'],
        detail:  @body['MessageDetail'],
      }
    end
  end

  class RequestError < ExchangeApiError; end

  class ServerError  < ExchangeApiError
    attr_accessor :server_status
    def initialize(response)
      super(response)
      @server_status = {
        type:    @body['ExceptionType'],
        message: @body['ExceptionMessage'],
        stack:   @body['StackTrace'].split(/[\r\n]+/),
      }
    end
  end

  class UnparseableApiError < ExchangeApiError
    attr_reader :code, :body, :response
    def initialize(response)
      @response = response
      @code = response.code
      @body = response.body
    end
  end
end
