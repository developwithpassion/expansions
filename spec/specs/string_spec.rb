require 'spec_helper'

module DevelopWithPassion
  module Expander
    describe String do
      context "when formatted as a home item" do
        it "should return the item as a path with the home directory as the root" do
          "hello".as_home_file.should == File.join(ENV["HOME"],"hello") 
        end
      end
    end
  end
end
