module Expansions
  class FileMerge
    include ArrayFu
    attr_accessor :read_original_contents

    array :before_files do
      read_and_write

      mutator :add_before_original_contents do |file| 
        add_merge_file(@before_files,file) 
      end

      mutator :add do |file| 
        add_before_original_contents(file) 
      end
    end

    array :after_files do
      read_and_write

      mutator :add_after_original_contents do |file| 
        add_merge_file(@after_files,file) 
      end
    end

    def initialize(output_file)
      super
      @output_file = output_file
      @read_original_contents = true
    end

    def dont_read_original_file_contents
      @read_original_contents = false
    end

    def run
      copy_name = File.join(File.dirname(@output_file),"copy_of_#{File.basename(@output_file)}")
      FileUtils.cp @output_file, copy_name if File.exist?(@output_file)
      FileUtils.rm_f @output_file
      File.open_for_write(@output_file) do |file|
        merge_files(@before_files,file)
        write_contents(file,copy_name) if @read_original_contents && File.exist?(copy_name)
        merge_files(@after_files,file)
      end
      FileUtils.rm_f copy_name if File.exist?(copy_name)
    end

    def write_contents(target_file_stream,file_to_read)
      File.open_for_read(file_to_read) do|line|
        target_file_stream << line
      end
    end

    def merge_files(source_files,target)
      source_files.each do|source|
        write_contents(target,source) 
      end
    end

    def add_merge_file(items,file)
      return if items.include?(file)
      items << file if File.exist?(file)
    end
  end
end
