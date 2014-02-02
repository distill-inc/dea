require 'date'
require 'time'
require 'singleton'

require 'json'
require 'queryparams'
require 'typhoeus'

require 'dea/api'
require 'dea/api_model'
require 'dea/config'
require 'dea/exceptions'
require 'dea/http'
require 'dea/version'
require 'dea/models/event'
require 'dea/models/user'

module Dea
  def self.config
    Dea::Config.instance
  end
end
