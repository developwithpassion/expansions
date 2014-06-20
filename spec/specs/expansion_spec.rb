require 'spec_helper'

module Expansions
  describe Expansion do
    let(:sources){[]}
    let(:mark_executable_visitor){fake}
    let(:dos_2_unix_visitor){fake}
    let(:rm_rf_visitor){fake}
    let(:module_factory){fake}

    context "when specifying a copy" do
      before (:each) do
        @sut = Expansion.new
      end

      before (:each) do
        @sut.copy_to "blah" do
        end
      end

      it "should not affect the merges" do
        @sut.files_to_merge.count.should == 0
      end

      it "should add a new copy element to the list of copies to be performed" do
        @sut.copies.values.count.should == 1
        @sut.copies[:blah].should be_an(Copy)
      end
    end

    context "when specifying a merge" do
      before (:each) do
        @sut = Expansion.new
      end
      before (:each) do
        @sut.merge_to "blah" do
        end
      end

      it "should not alter the copy files" do
        @sut.copies.count.should == 0
      end

      it "should add a new copy element to the list of copies to be performed" do
        @sut.files_to_merge.values.count.should == 1
        @sut.files_to_merge[:blah].should be_an(FileMerge)
      end
    end

    context "when a cleanup is specified" do
      before (:each) do
        @sut = Expansion.new
      end
      before (:each) do
        @sut.cleanup do
        end
      end
      it "should be added to the set of cleanup blocks" do
        @sut.cleanup_items.count.should == 1
      end
    end

    class FakeVisitor
      attr_accessor :items
      def initialize
        @items = 0
      end
      def run_using(file)
        @items+=1
      end
    end

    context "when a set of templates is specified" do
      let(:path){"**/*"}
      let(:template_visitor){FakeVisitor.new}
      before (:each) do
        TemplateVisitor.stub(:instance).and_return(template_visitor)
        @files = %w[1 2 3 4]
        Kernel.stub(:glob).with(path).and_return(@files)
        @sut = Expansion.new
        @sut.globber = lambda{|the_path, exclusion| 
          the_path.should == path
          files = []
          @files.each do |file|
            files << file unless exclusion.call(file)
          end
          return files
        }
      end

      context 'and a filter is not provided' do
        before (:each) do
          @sut.look_for_templates_in(path)
        end

        it "should process each of the loaded templates using the template visitor" do
          template_visitor.items.should == 4
        end
      end

      context 'and a filter is provided' do
        before (:each) do
          @sut.look_for_templates_in(path, exclude: -> (file) { /1/ =~ file })
        end

        it 'should only process the templates that were not filtered' do
          template_visitor.items.should == 3 
        end
      end


    end

    context "when a before is specified" do
      before (:each) do
        @sut = Expansion.new
      end
      before (:each) do
        @sut.before do
        end
      end
      it "should be added to the set of setup blocks" do
        @sut.setup_items.count.should == 1
      end
    end
  end
end
