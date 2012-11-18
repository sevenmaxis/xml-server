require File.join(File.dirname(__FILE__), '..', 'lib', 'xml.rb')

class Device
  def self.call(env)

    request = Rack::Request.new(env)

    response = Rack::Response.new
    response.body = ["Not Found"]
    response.status = 404

    if request.path == '/device'

      if request.get?

        response.status = 200
        response.body = [Xml.to_json]

      elsif request.post?

        response.status = 201

        begin
          
          Xml.update({"device" => request.params["device"]})
          response.body = [{ :success => true }.to_json]
          
        rescue XML::XXPathError, XML::Mapping::SingleAttributeNode::NoAttrValueSet

          response.body = [{ :success => false }.to_json]
          
        end        
      end
    end

    response.finish
  end  
end
