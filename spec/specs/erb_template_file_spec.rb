require 'spec_helper'

module DevelopWithPassion
  module Expander
    describe ERBTemplateFile do
      before (:each) do
        @original_template = <<-original
This is the first line @item@
This is the second line @item@
        original
      end
      context "when preparing a template" do
        let(:sut){ERBTemplateFile.new}

        before (:each) do
          @result = sut.prepare_template(@original_template)
        end

        it "should replace all occurences of @item@ with <%=item %>" do
          @expected = <<-template
This is the first line <%= item %>
This is the second line <%= item %>
          template

          @result.should == @expected
        end
      end
      context "when processing" do
        let(:item){"yo"}
        let(:file){fake}
        let(:file_name){"blah.rb"}
        let(:sut){ERBTemplateFile.new}

        before (:each) do
          @filesystem = RelativeFileSystem.new
          @output = RelativeFileSystem.file_name("out.rb")
          @original_template = <<-original
This is the first line @item@
This is the second line @item@
          original

          File.stub(:read).with(file_name).and_return(@original_template)
        end

        after(:each) do
          @filesystem.teardown
        end

        before (:each) do
          sut.process(:input => file_name,:output => @output,:binding => binding)
        end

        it "should expand everything" do
          @expected = <<-template
This is the first line #{item}
This is the second line #{item}
template

File.read_all_text(@output).should == @expected
        end

      end
    end
  end
end
