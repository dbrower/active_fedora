require 'spec_helper'

describe ActiveFedora::RdfDcHelper do

  describe "decode_dcsv" do
    it "handles escaped characters" do
      output = ActiveFedora::RdfDcHelper.decode_dcsv("a;b\\;c=hello;d\\=nothing=nothing;e;")
      output.should == {  0 => "a",
                          "b;c" => "hello",
                          "d=nothing" => "nothing",
                          1 => "e"
                       }
    end
    it "handles values with escaped =" do
      output = ActiveFedora::RdfDcHelper.decode_dcsv("a;b\\=c;d;")
      output.should == {  0 => "a",
                          1 => "b=c",
                          2 => "d"
                       }
    end
  end

  describe "encode_dcsv" do
    it "escapes strings correctly" do
      output = ActiveFedora::RdfDcHelper.encode_dcsv("=ab;")
      output.should == "\\=ab\\;"
    end
    it "converts hashes recursively" do
      output = ActiveFedora::RdfDcHelper.encode_dcsv({"a" => "b", "c=d" => ";"})
      output.should == "a=b; c\\=d=\\;"
    end
    it "notices array indexing and encodes that" do
      output = ActiveFedora::RdfDcHelper.encode_dcsv({0 => "a=b", 1 => ";", 2 => "asdf", "123" => "+345"})
      output.should == "a\\=b; \\;; asdf; 123=+345"
    end
  end
end

