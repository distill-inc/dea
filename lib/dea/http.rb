module Dea
  class Http
    class << self
      def api_call(method, path, options = {})
        @path = append_params_to_path(path, options[:params])
        headers = {"Content-Type" => "application/json"}
        headers["X-Distill-Token"] = options[:auth_token] if options[:auth_token]

        request = Typhoeus::Request.new("#{Dea.config.server_address}#{@path}",
          method:  method,
          headers: headers,
          body:    options[:body].to_json)
        handle_response(request.run)
      end

      def append_params_to_path(path, params)
        return path if params.nil?
        query   = params.map{|key, val| "#{key}=#{val}" }.join("&")
        symbol  = path[/\?/] ? '&' : '?'
        "#{path}#{symbol}#{query}"
      end

      def handle_response(response)
        case response.code.to_i
        when 400...500
          raise RequestError.new(response)
        when 500...600
          raise ServerError.new(response)
        else
          JsonResponse.new(response)
        end
      end

      ACCEPTABLE_API_METHODS = %w(get post put delete)
      def method_missing(method, *args)
        return super unless ACCEPTABLE_API_METHODS.include?(method.to_s)
        api_call(method.to_sym, *args)
      end
    end
  end

  class JsonResponse
    attr_reader :response_code, :json_object

    def initialize(response)
      @response_code = response.code
      @json_object = {}
      json = JSON.load(response.body)
      return if json.nil?
      json.each do |key, value|
        @json_object[underscore(key)] = value
      end
    end

    private


    def method_missing(method, *args)
      if @json_object.keys.include?(method.to_s)
        @json_object[method.to_s]
      else
        super
      end
    end

    # modified from activesupport/lib/active_support/inflector/methods.rb
    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
