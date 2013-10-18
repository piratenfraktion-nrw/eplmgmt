require 'spec_helper'

describe 'Pads' do
  describe 'GET /p' do
    it 'works' do
      get named_pads_path
      response.status.should be(200)
    end
  end
end
