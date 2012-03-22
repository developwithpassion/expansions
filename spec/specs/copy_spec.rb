require 'spec_helper'

module DevelopWithPassion
  module Expander
    class AFakeVisitor
      def initialize
        array :sources do|a| 
          a.readable
          a.writable
          a.mutator :run_using
        end
      end
    end
    describe Copy do
      let(:sources){[]}
      let(:copy_visitor){AFakeVisitor.new}

      before (:each) do
        @sut = Copy.new(copy_visitor)
        @sut.sources = sources
      end

      context "when a folder is registered" do
        let(:folder){"item"}

        before (:each) do
          @sut.folder(folder)
        end

        it "should be placed in the list of sources" do
          sources[0].should == folder
        end
      end

      context "when the contents of a folder is registered" do
        let(:folder){"item"}

        before (:each) do
          @sut.contents(folder)
        end

        it "should be placed in the list of sources" do
          sources[0].should == "#{folder}/."
        end
      end

      context "when copying contents in a set of folders" do
        let(:folder){"item"}

        before (:each) do
          @sut.all_contents_in(%w[1 2])
        end

        it "should place all of the folders in the sources set" do
          sources[0].should == "1/."
          sources[1].should == "2/."
        end
      end

      context "when copying folders in a set of folders" do
        let(:folder){"item"}

        before (:each) do
          @sut.all_folders_in(%w[1 2])
        end

        it "should place all of the folders in the sources set" do
          sources[0].should == "1"
          sources[1].should == "2"
        end
      end
      context "when expanding all of the items" do
        let(:folder){"item"}

        before (:each) do
          %w[1 2 3].each{|item| sources << item}
        end

        before (:each) do
          @sut.run
        end

        it "should copy each of the sources tot he target" do
          copy_visitor.sources.count.should == 3
        end
      end
    end
  end
end
