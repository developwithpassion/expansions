module DevelopWithPassion
  module Expander
    class MustacheTemplateFile
      def process(args)
        template = File.read_all_text(args[:input])

        File.open_for_write(args[:output]){|file| file << Mustache.render(template,configatron.to_hash)}
      end
    end
  end
end
