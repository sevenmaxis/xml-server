require 'xml/mapping'
require "rexml/document"
require File.join(File.dirname(__FILE__), '..', 'lib', 'patch_hash.rb')

module Xml
  XPATH = 'CustomerResponse/User/Device'

  @@xml_file = File.expand_path( File.join(File.dirname(__FILE__), "task.xml"))

  class << self

    def setup
      load_xml
      setup_map
    end

    def set_xml(file_path)
      @@xml_file = file_path
      @@doc = REXML::Document.new( File.new(@@xml_file) ).tap { setup_map }
    end

    def get_xml
      @@doc
    end

    def get_map
      @@map
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      @@map.nested_dup.nested_each do |hash,key,value|
        hash[key] = XML::XXPath.new(value).first(@@doc).text
      end
    end

    def update(to_update)
      puts ""
      updated = false
      puts "before updated: #{updated}"

      @@map.nested_merge(to_update) do |key, xpath, new_value|
        updated = true
        XML::XXPath.new(xpath).first(@@doc).text = new_value
      end

      if updated
        @@doc.write( File.new(@@xml_file,'w'), 2)      
      else
        raise XML::Mapping::SingleAttributeNode::NoAttrValueSet
      end
    end

    private

    def load_xml
      @@doc = REXML::Document.new( File.new(@@xml_file) )
    end

    def setup_map
      @@map = { 
        "device" => {
          "username" => "#{XPATH}/DeviceID/@DefaultDID",
          "name" => "#{XPATH}/DeviceID/@Name",
          "location" => "#{XPATH}/Privileged/Identification/@Location",
          "numbers" => generate_numbers
        }
      }
    end

    def generate_numbers
      numbers = XML::XXPath.new("#{XPATH}/DID").all(@@doc)
      numbers.size.times.map do |i|
        {
          "number" => "#{XPATH}/DID[#{i+1}]/@E164",
          "vnum_id" => "#{XPATH}/DID[#{i+1}]/@VNumID",
          "starcode" => "#{XPATH}/DID[#{i+1}]/@StarCode",
          "ring_pattern" => "#{XPATH}/DID[#{i+1}]/@RingPattern"
        }
      end
    end
  end

  setup
  
end
