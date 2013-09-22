require "spec_helper"

describe GroupUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/group_users").should route_to("group_users#index")
    end

    it "routes to #new" do
      get("/group_users/new").should route_to("group_users#new")
    end

    it "routes to #show" do
      get("/group_users/1").should route_to("group_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/group_users/1/edit").should route_to("group_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/group_users").should route_to("group_users#create")
    end

    it "routes to #update" do
      put("/group_users/1").should route_to("group_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/group_users/1").should route_to("group_users#destroy", :id => "1")
    end

  end
end
