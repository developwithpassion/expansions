require 'spec_helper'

module Expansions
  describe File do
    let(:file_system){RelativeFileSystem.new}

    context "when opening a file for read" do
      let(:file){RelativeFileSystem.file_name("blah.rb")}
      before (:each) do
        file_system.write_file("blah.rb","sdf\nnsfsf")
        @number_of_lines_visited = 0
      end

      after (:each) do
        file_system.teardown
      end

      before (:each) do
        File.open_for_read(file){|line| @number_of_lines_visited +=1}
      end

      it "should open the file and run the block against each line in the file" do
        @number_of_lines_visited.should == 2 
      end
    end

    context "when reading all the text in a file" do
      let(:file){RelativeFileSystem.file_name("blah.rb")}
      let(:contents){<<-content
                       hello
                       this is 
                       a file
                     content
      }
      before (:each) do
        file_system.write_file("blah.rb",contents)
      end

      after (:each) do
        file_system.teardown
      end

      before (:each) do
        @result = File.read_all_text(file)
      end

      it "should return the total contents" do
        @result.should == contents
      end
    end

    context "when reading all the text in a file after skipping lines" do
      let(:file){RelativeFileSystem.file_name("blah.rb")}
      let(:start){"this is the file\n"}
      let(:contents){<<-content
                       hello
                       this is 
                       a file
                     content
      }
      let(:all_contents){"#{start}#{contents}"}
      before (:each) do
        file_system.write_file("blah.rb",all_contents)
      end

      after (:each) do
        file_system.teardown
      end

      before (:each) do
        @result = File.read_all_text_after_skipping_lines(file,1)
      end

      it "should return the contents except the skipped lines" do
        @result.should == contents
      end
    end
  end
end
