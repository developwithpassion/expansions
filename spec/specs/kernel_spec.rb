require 'spec_helper'

module Kernel
  describe Kernel do
    context "when globbing for files" do
      before (:each) do
        @file_system = RelativeFileSystem.new
        @file_system.write_file("1.rb","sdfsdfsdf")
        @file_system.write_file("2.rb","sdfsdfsdf")
        (1..2).each do|item|
          @file_system.write_file("#{item}.rb","sdfsdf")
          @file_system.write_file(".#{item}","sdfsdf")
          (1..2).each do|folder|
            new_folder = RelativeFileSystem.file_name("#{folder}")
            file = File.join(new_folder,"#{folder}.rb")
            @file_system.write_file(file,"sdfsd")
          end
        end
      end

      after (:each) do
        # @file_system.teardown
      end

      context "and no block is given" do
        before (:each) do
          @result = glob(File.join(RelativeFileSystem.base_path,"**/*"))
        end

        it "should return all files in path including dotfiles" do
          @result.count.should == 16
        end
      end
      context "and a block is given" do
        before (:each) do
          @items_visited = 0
        end
        before (:each) do
          @result = glob(File.join(RelativeFileSystem.base_path,"**/*")) do |file|
            @items_visited += 1
          end
        end

        it "should return all files in path including dotfiles" do
          @result.count.should == 16
        end

        it "should have run the block against each file" do
          @items_visited.should == 16
        end
        
      end
      
    end
  end 
end
