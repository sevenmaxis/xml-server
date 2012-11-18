require "rubygems"
require "rack"
require 'json'
require "minitest/autorun"
require File.expand_path("../../lib/device", __FILE__)

describe Device do
  before do
    @request = Rack::MockRequest.new(Device)
  end

  it "returns a 404 response for unknown requests" do
    @request.get("/unknown").status.should == 404
    @request.get("/").status.should == 404
  end

  it "/device returns JSON response" do
    response = @request.get("/device")
    hash = {
      device: {
        username:"6504335037", name:"", location:"Shared",
        numbers: [
          { number:"16508045104", vnum_id:"0", starcode:"0", ring_pattern:"2" },
          { number:"16504335037", vnum_id:"1", starcode:"1", ring_pattern:"0" },
          { number:"16504750480", vnum_id:"3", starcode:"3", ring_pattern:"0" }
        ]
      }
    }
    response.body.should == hash.to_json
  end

  describe "Post create" do

    before do
      require File.expand_path("../../lib/xml", __FILE__)
      path = File.join(File.dirname(__FILE__), 'task.xml')
      @update_path = File.join(File.dirname(__FILE__), 'update_task.xml')
      FileUtils.cp path, @update_path
      Xml.set_xml(@update_path)
    end

    it "/device post with invalid params should'n change xml" do
      params = { :device => { :slkjfdsjfds => "eruewur" } }
      response = @request.post("/device", params: params.to_json)
      response.status.should == 201
      hash = { :success => false }
      response.body.should == hash.to_json
    end

    it "/device post with valid params should change xml" do
      params = { 
        :device => {
          :username => "12345678", :name => "foo", :location => "hiden" 
        }
      }
      response = @request.post("/device", params: params.to_json)
      response.status.should == 201
      hash = { :success => true}
      response.body.should == hash.to_json
    end

    after do
      FileUtils.rm @update_path
    end
  end
end
