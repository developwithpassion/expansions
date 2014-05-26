module Expansions
  class TemplateVisitor
    attr_reader :processors
    attr_reader :file
    DOT_FILE_PATTERN = /\.dotfile/

    def initialize(args = {})
      @processors = args.fetch(:processor_registry, TemplateProcessors.instance)
      @file = args.fetch(:file, File)
    end

    def run_using(file_name)
      processor = processors.get_processor_for(file_name)

      generated_name = File.basename(file_name,File.extname(file_name))

      load_settings_file(File.dirname(file_name), generated_name)

      generated_name = generated_name.gsub(DOT_FILE_PATTERN, "") 

      generated_name = ".#{generated_name}" if (DOT_FILE_PATTERN =~ file_name) 

      output = File.join(File.dirname(file_name),generated_name)

      file.delete(output) if file.exists?(output)

      processor.process(:input => file_name,:output => output)
    end

    def load_settings_file(folder, file_name)
      settings_file = File.join(folder, "#{file_name}.settings")

      if File.exist?(settings_file)
        load settings_file
      end
    end
  end
end
