require 'webmock/rspec'
require 'dea'

SPEC_ROOT = File.dirname(__FILE__)

def fixture(name)
  File.open(File.join(SPEC_ROOT, '/fixtures/', name)).read
end

Dea.config.server_address = 'http://localhost:3000/dea/'
