require 'spec_helper'

module Expansions
  describe FileMerge do
    context "when a file is added to the merge" do
      let(:file){"file.rb"}
      let(:output_file){"out_file.rb"}
      let(:sut){FileMerge.new(output_file)}
      before (:each) do
        File.stub(:exists?).with(file).and_return(true)
      end
      context "and it is not already in the list" do
        before (:each) do
          sut.add(file)
        end
        it "should be added to the list of before files" do
          sut.before_files[0].should == file
        end
      end
      context "and it is already in the list" do
        before (:each) do
          sut.before_files << file
        end
        before (:each) do
          sut.add(file)
        end
        it "should not be added to the list of before files" do
          sut.before_files.count.should == 1
        end
      end

    end

    context "when a file is added after the original contents" do
      let(:file){"file.rb"}
      let(:output_file){"out_file.rb"}
      let(:sut){FileMerge.new(output_file)}
      before (:each) do
        File.stub(:exists?).with(file).and_return(true)
      end

      before (:each) do
        sut.add_after_original_contents(file)
      end

      it "should be added to the set of after files" do
        sut.after_files[0].should == file
      end
    end

    context "when a set of files are merged to a target file" do
      let(:target){RelativeFileSystem.file_name("merged.rb")}
      let(:sut){FileMerge.new(target)}
      before (:each) do
        @file_system = RelativeFileSystem.new
        @file_system.write_file("1.rb","first\n")
        @file_system.write_file("2.rb","second\n")
        @file_system.write_file("3.rb","third\n")
      end
      after (:each) do
        @file_system.teardown
      end
      before (:each) do
        files = [1,2,3].map{|item| RelativeFileSystem.file_name("#{item}.rb")}.to_a
        File.open_for_write(target) do|file|
          sut.merge_files(files,file)
        end
      end
      it "the target file should contain all of the file contents" do
        IO.read(target).should == "first\nsecond\nthird\n"
      end
    end

    context "when a merge occurs" do
      let(:target){RelativeFileSystem.file_name("original.rb")}
      let(:sut){FileMerge.new(target)}
      let(:first){"1.rb"}
      let(:second){"2.rb"}
      let(:third){"3.rb"}
      let(:original){"original.rb"}

      before (:each) do
        @file_system = RelativeFileSystem.new
        @file_system.write_file("1.rb","first\n")
        @file_system.write_file("2.rb","second\n")
        @file_system.write_file("3.rb","third\n")
        @file_system.write_file("original.rb","original\n")
      end

      after (:each) do
        @file_system.teardown
      end

      context "and original contents are flagged to be read" do
        before (:each) do
          sut.add_before_original_contents(RelativeFileSystem.file_name(first))
          sut.add_before_original_contents(RelativeFileSystem.file_name(second))
          sut.add_after_original_contents(RelativeFileSystem.file_name(third))
        end

        before (:each) do
          sut.run
        end

        it "should output the correct contents" do
          contents = IO.read(target)
          contents.should == "first\nsecond\noriginal\nthird\n" 
        end
      end

      context "and original contents are not flagged to be read" do
        before (:each) do
          sut.add_before_original_contents(RelativeFileSystem.file_name(first))
          sut.add_before_original_contents(RelativeFileSystem.file_name(second))
          sut.add_after_original_contents(RelativeFileSystem.file_name(third))
          sut.dont_read_original_file_contents
        end

        before (:each) do
          sut.run
        end

        it "should output the correct contents" do
          contents = IO.read(target)
          contents.should == "first\nsecond\nthird\n" 
        end
      end

    end
  end
end
