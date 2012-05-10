module Expansions
  class FileMerge
    attr_accessor :read_original_contents

    def initialize(output_file)
      array :before_files do|a|
        a.read_and_write
        a.mutator :add_before_original_contents do |file| add_merge_file(@before_files,file) end
        a.mutator :add do|file| add_before_original_contents(file) end
      end
      array :after_files do|a|
        a.read_and_write
        a.mutator :add_after_original_contents do|file| add_merge_file(@after_files,file) end
      end
      @output_file = output_file
      @read_original_contents = true
    end

    def dont_read_original_file_contents
      @read_original_contents = false
    end

    def run
      copy_name = "_copy_of#{File.basename(@output_file)}"
      FileUtils.cp @output_file,copy_name
      FileUtils.rm_f @output_file
      File.open_for_write(@output_file) do |file|
        do_merge copy_name,file
      end
      FileUtils.rm copy_name
    end

    def do_merge(temp_file,target_file)
      merge_files(@before_files,target_file)
      if @read_original_contents
        File.open_for_read temp_file do|line|
          target_file << line
        end
      end
      merge_files(@after_files,target_file)
    end

    def merge_files(source_files,target)
      source_files.each do|source|
        File.open_for_read source do|line|
          target << line
        end
      end
    end

    :private
    def add_merge_file(items,file)
      return if items.include?(file)
      items << file if File.exists?(file)
    end
  end
end
