module Expansions
  class Startup
    def self.run
      [
        TemplateProcessors,
        TemplateVisitor,
        Expansion,
        Shell
      ].each{|item| item.send(:include,Singleton)}

      TemplateProcessors.instance.register_processor(:erb,ERBTemplateFile.new)
      TemplateProcessors.instance.register_processor(:mustache,MustacheTemplateFile.new)

      enable_logging
    end
  end
end
