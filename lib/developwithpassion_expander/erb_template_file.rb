module DevelopWithPassion
  module Expander
    class ERBTemplateFile
      def prepare_template(template)
        token_regex = /(@\w[\w\.\_]+\w@)/

        hits = template.scan(token_regex)
        tags = hits.map do |item|
          item[0].gsub(/@/,'').squeeze
        end
        tags = tags.map{|tag| tag.to_sym}.uniq

        tags.inject(template) do |text, tag|
          text.gsub /@#{tag.to_s}@/, "<%= #{tag.to_s} %>"
        end
      end

      def process_template(template,binding)
        erb = ERB.new(template, 0, "%")
        erb.result(binding)
      end

      def process(args)
        template = prepare_template(File.read(args[:input]))
        result = process_template(template,args[:binding])

        File.open_for_write(args[:output]) do|file|
          file.write(result)
        end
      end
    end
  end
end
