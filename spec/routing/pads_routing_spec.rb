require "spec_helper"

describe PadsController do
  describe "routing" do

    it "routes to #index" do
      get("/pads").should route_to("pads#index")
    end

    it "routes to #new" do
      get("/pads/new").should route_to("pads#new")
    end

    it "routes to #show" do
      get("/pads/1").should route_to("pads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pads/1/edit").should route_to("pads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pads").should route_to("pads#create")
    end

    it "routes to #update" do
      put("/pads/1").should route_to("pads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pads/1").should route_to("pads#destroy", :id => "1")
    end

  end
end
