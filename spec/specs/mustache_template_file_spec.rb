require 'spec_helper'
require 'configatron'

module Expansions
  describe MustacheTemplateFile do
    context "when processing" do
      before (:each) do
        @original_template = <<-original
This is the first line {{ hello }}
This is the second line {{ hello }}
        original
      end

      let(:sut){MustacheTemplateFile}

      configure :hello => 'world'

      before (:each) do
        @filesystem = RelativeFileSystem.new
        @output = RelativeFileSystem.file_name("out.rb")
        @file_name = RelativeFileSystem.file_name("blah.rb")

        @filesystem.write_file("blah.rb",@original_template)

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
This is the first line world
This is the second line world
        template

        IO.read(@output).should == @expected
      end

    end

    context "when processing with nested parameters" do
      before (:each) do
        @original_template = <<-original
This is the first line {{{my.github.username}}}
        original

        details = { 
          my: 
          { 
            username: 'jp',
            github: 
            {
              username: 'jp' 
            } 
          }
        }
        configure(details)
      end
      let(:sut){MustacheTemplateFile}


      before (:each) do
        @filesystem = RelativeFileSystem.new
        @output = RelativeFileSystem.file_name("out.rb")
        @file_name = RelativeFileSystem.file_name("blah.rb")

        @filesystem.write_file("blah.rb",@original_template)

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
This is the first line jp
        template

        IO.read(@output).should == @expected
      end

    end
  end
end
