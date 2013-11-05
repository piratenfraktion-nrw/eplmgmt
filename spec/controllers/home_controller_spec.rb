require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    login_user
    it 'should be successful if logged in' do
      get 'index'
      response.status.should be(200)
    end
  end

end
