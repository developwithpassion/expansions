require 'spec_helper'

describe Enumerable do
  class Visitor
    attr_accessor :items_processed

    def initialize
      @items_processed = 0
    end
    def run_using(item)
      @items_processed += 1
    end
  end
  context "when processing each item with a visitor" do
    let(:visitor){Visitor.new}
    let(:items){(1..10).to_a}

    before (:each) do
      items.process_all_items_using(visitor)  
    end

    it "should run each item against the visitor" do
      visitor.items_processed.should == 10
    end
  end
end

