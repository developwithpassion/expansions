module DevelopWithPassion
  module Expander
    class Shell
      def run(cmd)
        return `#{cmd}`
      end
    end
  end
end
