require 'spec_helper'

describe 'Groups' do
  describe 'GET /groups' do
    it 'should redirect to pads if not logged in' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get groups_path
      response.status.should be(302)
    end
  end
end
