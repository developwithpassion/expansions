module DevelopWithPassion
  module Expander
    class CopyToTarget
      def initialize(target)
        @target = target
      end

      def run_using(source_item)
        Shell.instance.run("cp -rf #{source_item} #{@target}")
      end
    end
  end
end
