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
      names = get_file_names(file_name)
      load_settings_file(names[:settings_file])
      output = names[:output_file_name]
      file.delete(output) if file.exists?(output)

      begin
        processor.process(:input => file_name,:output => output)
      rescue Exception => e
        raise "Error processing template file: #{file_name}"
      end
    end

    def get_file_names(file_name)
        base_name = File.basename(file_name, File.extname(file_name))
        dir_name = File.dirname(file_name)
        generated_name = base_name.gsub(DOT_FILE_PATTERN, "") 
        generated_name = ".#{generated_name}" if (DOT_FILE_PATTERN =~ file_name) 
        output_file_name = File.join(dir_name, generated_name)
        settings_file = File.join(dir_name, "#{base_name}.settings")

        {
          settings_file: settings_file,
          output_file_name: output_file_name
        }
    end

    def load_settings_file(settings_file)
      load settings_file if File.exist?(settings_file)
    end
  end
end
