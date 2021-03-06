module Expansions
  class TemplateProcessors
    attr_reader :processors

    def initialize(processors={})
      @processors = processors
    end

    def get_processor_for(file_name)
      template_type = File.extname(file_name).gsub(/\./,'').to_sym

      raise "There is no processor for #{file_name}" unless processor?(template_type)

      return processors[template_type]
    end

    def register_processor(template_type,processor)
      raise "The processor for the template already exists" if processor?(template_type)

      processors[template_type.to_sym] = processor
    end

    def processor?(template_type)
      return processors.has_key?(template_type.to_sym)
    end
  end
end
