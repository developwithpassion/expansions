require 'spec_helper'
require 'configatron'

module Expansions
  describe MustacheTemplateFile do
    before (:each) do
      @original_template = <<-original
This is the first line {{ item }}
This is the second line {{ item }}
      original
    end
    context "when processing" do
      let(:item){"yo"}
      let(:sut){MustacheTemplateFile.new}

      configatron.configure_from_hash :hello => "world"

      before (:each) do
        @filesystem = RelativeFileSystem.new
        @output = RelativeFileSystem.file_name("out.rb")
        @file_name = RelativeFileSystem.file_name("blah.rb")

        @filesystem.write_file("blah.rb",@original_template)

        configatron.stub(:to_hash).and_return(:item => item)
        File.stub(:read_all_text).with(@file_name).and_return(@original_template)
      end

      after(:each) do
        @filesystem.teardown
      end

      before (:each) do
        sut.process(:input => @file_name,:output => @output)
      end

      it "should expand everything" do
        @expected = <<-template
This is the first line #{item}
This is the second line #{item}
template

IO.read(@output).should == @expected
      end

    end
  end
end
