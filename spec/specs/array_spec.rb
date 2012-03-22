require 'spec_helper'

module DevelopWithPassion
  module Expander
    describe Array do
      it "should be able to return the array contents as a glob pattern" do
        items = %w[this is cool **/*.rb]
        %w[this is cool **/*.rb].as_glob_pattern.should == File.join(items)
      end

      it "should map each item as a home item" do
        items = %w[this is cool]
        items.as_home_files.should == items.map{|item| item.as_home_file}
      end

      it "should be able to be converted to a glob pattern" do
        %w[this is cool].as_glob_pattern.should == "this/is/cool" 
      end

    end
  end
end
