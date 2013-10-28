require 'spec_helper'

describe PadsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/p').should route_to('home#pads')
    end

    it 'routes to #new' do
      get('/groups/1/pads/new').should route_to('pads#new', group_id: '1')
    end

    it 'routes to #show' do
      get('/p/testungrouped').should route_to('pads#show', :pad => 'testungrouped')
    end

    it 'routes to #show' do
      get('/p/group/testgrouped').should route_to('pads#show', :group => 'group', :pad => 'testgrouped')
    end

    it 'routes to #edit' do
      get('/groups/1/pads/1/edit').should route_to('pads#edit', group_id: '1', :id => '1')
    end

    it 'routes to #create' do
      post('/groups/1/pads').should route_to('pads#create', group_id: '1')
    end

    it 'routes to #update' do
      put('/groups/1/pads/1').should route_to('pads#update', group_id: '1', :id => '1')
    end

    it 'routes to #destroy' do
      delete('/groups/1/pads/1').should route_to('pads#destroy', group_id: '1', :id => '1')
    end

  end
end