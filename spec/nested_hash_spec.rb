require File.expand_path("../../lib/patch_hash", __FILE__)

describe Hash do

  before do
    @h = { k: 4, z: { :l => 5} }
  end

  it "should iterate through every node in hash" do
    @h.nested_each.map { |_,k,v| [k,v] }.should == [[:k,4], [:l,5]]
  end

  it "should change every value in hash" do
    @h.nested_each { |h,k,v| h[k] = v + 1 }.should == { k: 5, z: { :l => 6} }
  end

  it "should merge nested hashes" do
    count = 0
    @h.nested_merge(@h) do |key, oldval, newval|
      count += 1
    end
    count.should == 2
  end

  it "bug with two hashes" do
    h = {
      :device => { 
        :username => "12345678",
        :name => "foo",
        :location => "hiden"
      }
    }
    a = []
    h.nested_merge(h) do |key, oldval, newval|
      oldval.should_not be_an_instance_of(Hash)
      newval.should_not be_an_instance_of(Hash)
      a << oldval
    end
    a.should == ["12345678", "foo", "hiden"]
  end

  it "patched deep dup" do
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
    k = hash.nested_dup
    k['device']['numbers'][0]['number'] = 'foo'
    hash['device']['numbers'][0]['number'].should == "16508045104"
  end
end
