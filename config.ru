#require 'xml'
require "device"

#use Rack::Reloader, 0
#Xml.setup

run Rack::Cascade.new([Rack::File.new("public"), Device])
