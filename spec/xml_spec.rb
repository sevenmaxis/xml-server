require File.expand_path("../../lib/xml", __FILE__)

describe Xml do
  
  before do
    @path = File.join(File.dirname(__FILE__), 'task.xml')
  end

  it "should load REXML document" do
    doc = Xml.set_xml(@path)

    doc.root.attributes['xmlns'].should == 'http://corp.ooma.internal/namespaces/customer'
    doc.root.attributes['ProcTime'].should == '287'
    doc.root.attributes['Action'].should == 'GET_ADMUSER'
  end

  it "should be initialized on start" do
    doc = Xml.get_xml

    doc.root.attributes['xmlns'].should == 'http://corp.ooma.internal/namespaces/customer'
    doc.root.attributes['ProcTime'].should == '287'
    doc.root.attributes['Action'].should == 'GET_ADMUSER'
  end

  it "should build right map" do
    Xml.set_xml(@path)
    xpath = Xml::XPATH

    hash = { 
      "device" => {
        "username" => "#{xpath}/DeviceID/@DefaultDID",
        "name" => "#{xpath}/DeviceID/@Name",
        "location" => "#{xpath}/Privileged/Identification/@Location",
        "numbers" => [
          {
            "number" => "#{xpath}/DID[1]/@E164",
            "vnum_id" => "#{xpath}/DID[1]/@VNumID",
            "starcode" => "#{xpath}/DID[1]/@StarCode",
            "ring_pattern" => "#{xpath}/DID[1]/@RingPattern"
          },
          {
            "number" => "#{xpath}/DID[2]/@E164",
            "vnum_id" => "#{xpath}/DID[2]/@VNumID",
            "starcode" => "#{xpath}/DID[2]/@StarCode",
            "ring_pattern" => "#{xpath}/DID[2]/@RingPattern"
          },
          {
            "number" => "#{xpath}/DID[3]/@E164",
            "vnum_id" => "#{xpath}/DID[3]/@VNumID",
            "starcode" => "#{xpath}/DID[3]/@StarCode",
            "ring_pattern" => "#{xpath}/DID[3]/@RingPattern"

          }
        ]
      }
    }

    Xml.get_map.should == hash
  end

  it "should convert to hash" do
    doc = Xml.set_xml(@path)

    hash = {
      "device" => {
        "username" => "6504335037",
        "name" => "",
        "location" => "Shared",
        "numbers" => [
          {
            "number" => "16508045104",
            "vnum_id" => "0",
            "starcode" => "0",
            "ring_pattern" => "2"
          },
          {
            "number" => "16504335037",
            "vnum_id" => "1",
            "starcode" => "1",
            "ring_pattern" => "0"
          },
          {
            "number" => "16504750480",
            "vnum_id" => "3",
            "starcode" => "3",
            "ring_pattern" => "0"
          }
        ]
      }
    }

    Xml.to_hash.should == hash
  end

  it "should update xml documetn" do
    update_path = File.join(File.dirname(__FILE__), 'update_task.xml')
    FileUtils.cp @path, update_path
    
    doc = Xml.set_xml(update_path)
    
    to_update = {
      "device" => {
        "username" => "12345678",
        "name" => "foo",
        "location" => "hiden"
      }
    }

    Xml.update(to_update)

    doc = Xml.get_xml
    xpath = Xml::XPATH

    XML::XXPath.new("#{xpath}/DeviceID/@DefaultDID").
                first(doc).text.should == "12345678"
    XML::XXPath.new("#{xpath}/DeviceID/@Name").
                first(doc).text.should == "foo"
    XML::XXPath.new("#{xpath}/Privileged/Identification/@Location").
                first(doc).text.should == "hiden"

    FileUtils.rm update_path
  end

  it "should respond two times in a row" do
    doc = Xml.set_xml(@path)

    hash = {
      "device" => {
        "username" => "6504335037",
        "name" => "",
        "location" => "Shared",
        "numbers" => [
          {
            "number" => "16508045104",
            "vnum_id" => "0",
            "starcode" => "0",
            "ring_pattern" => "2"
          },
          {
            "number" => "16504335037",
            "vnum_id" => "1",
            "starcode" => "1",
            "ring_pattern" => "0"
          },
          {
            "number" => "16504750480",
            "vnum_id" => "3",
            "starcode" => "3",
            "ring_pattern" => "0"
          }
        ]
      }
    }

    Xml.to_hash.should == hash
    Xml.to_hash.should == hash

  end
end