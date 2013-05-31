class File
  class << self
    def open_for_read(file)
      File.open(file,'r').each do|line|
        yield line
      end
    end

    def read_all_text(file)
      File.read_all_text_after_skipping_lines(file,0)
    end

    def read_all_text_after_skipping_lines(file,number_of_lines_to_skip)
      index = 1
      contents = ''

      if File.exist?(file)
        File.open_for_read(file) do |line|
          contents += line if index > number_of_lines_to_skip
          index+=1
        end
      end

      return contents
    end

    def open_for_write(file)
      File.open(file,'w') do|new_file|
        yield new_file
      end
    end
  end
end
