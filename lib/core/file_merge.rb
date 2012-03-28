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
      original_contents = File.read_all_text(@output_file)
      FileUtils.rm_f @output_file
      File.open_for_write(@output_file) do |file|
        merge_files(@before_files,file)
        file.write original_contents if @read_original_contents
        merge_files(@after_files,file)
      end
    end

    def merge_files(source_files,target)
      source_files.each do|source|
        target.write File.read_all_text(source)
      end
    end

    :private
    def add_merge_file(items,file)
      return if items.include?(file)
      items << file if File.exists?(file)
    end
  end
end
