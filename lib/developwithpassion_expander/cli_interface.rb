module DevelopWithPassion
  module Expander
    class CLIInterface
      def startup
        [
          TemplateProcessors,
          TemplateVisitor,
          Expansion,
          Shell
        ].each{|item| item.send(:include,Singleton)}

        TemplateProcessors.instance.register_processor(:erb,ERBTemplateFile.new)
        TemplateProcessors.instance.register_processor(:mustache,MustacheTemplateFile.new)
      end

      def get_expansion_file_name(args)
        return args.count > 0 ? args[0] : "Expansionfile"
      end

      def ensure_expansion_file_provided(file)
        unless File.exist?(file)
          print <<-prompt
dwp_expand aborted!
No Expansionfile found (looking for: Expansionfile)
          prompt
          exit
        end
      end

      def run(args = [])
        file_to_run = get_expansion_file_name(args)
        ensure_expansion_file_provided file_to_run
        startup
        enable_logging
        log "Running Expansions defined in file:#{file_to_run}"
        load file_to_run
        Expansion.instance.run
      end
    end
  end
end
