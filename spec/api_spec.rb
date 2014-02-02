require 'spec_helper'

include Dea

describe Api do
  describe ".login" do
    it "receives token" do
      stub_request(:post, "#{Dea.config.server_address}login").
        to_return(status: 200, body: fixture('login_success.json'))

      login = Api.log_in('a', 'b', 'c')
      login.token.should == 'sample_token_value'
    end

    context "wrong login" do
      it "errors out" do
        stub_request(:post, "#{Dea.config.server_address}login").
          to_return(status: 400, body: fixture('login_error.json'))

        expect {
          Api.log_in('a', 'b', 'c')
        }.to raise_exception(RequestError)
      end
    end
  end

  describe '.users' do
    let(:users_list) { fixture('users.json') }
    before {
      stub_request(:get, "#{Dea.config.server_address}contacts").
        to_return(status: 200, body: users_list)
    }
    it "gets list of users" do
      Api.users('token').length.should == 2
    end

    it "gets user details" do
      user = Api.users('token').first
      user.name.should == JSON.load(users_list)['Contacts'][0]['DisplayName']
    end
  end

  describe '.events' do
    let(:events_list) { fixture('events.json') }
    before {
      stub_request(:get, "#{Dea.config.server_address}appointments").
        to_return(status: 200, body: events_list)
    }
  end
end
