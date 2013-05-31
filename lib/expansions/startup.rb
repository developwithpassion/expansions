module Expansions
  class Startup
    def self.run
      [
        TemplateProcessors,
        TemplateVisitor,
        Expansion,
        Shell
      ].each do |item| 
        item.send(:include, Singleton)
      end

      TemplateProcessors.instance.register_processor(:erb,ERBTemplateFile)
      TemplateProcessors.instance.register_processor(:mustache,MustacheTemplateFile)

      enable_logging
    end
  end
end
