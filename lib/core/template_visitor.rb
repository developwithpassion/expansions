module Expansions
  class TemplateVisitor
    def initialize(args = {})
      @processor_registry = args.fetch(:processor_registry,TemplateProcessors.instance)
      @file = args.fetch(:file,File)
    end

    def run_using(file_name)
      processor = @processor_registry.get_processor_for(file_name)
      generated_name = File.basename(file_name,File.extname(file_name))
      generated_name = generated_name.gsub(/\.dotfile/,"") 
      generated_name = ".#{generated_name}" if (/\.dotfile/ =~ file_name) 
      output = File.join(File.dirname(file_name),generated_name)
      @file.delete(output) if @file.exists?(output)
      processor.process(:input => file_name,:output => output)
    end
  end
end
