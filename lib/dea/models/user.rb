module Dea
  class User < ApiModel
    attr_accessor :name, :email

    def initialize(api_user)
      @name  = api_user["DisplayName"]
      @email = api_user["Email"]
    end
  end
end
