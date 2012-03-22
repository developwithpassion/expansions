module DevelopWithPassion
  module Expander
    class ShellActionAgainstFile
      def initialize(cmd)
        @cmd = cmd
      end
      def run_using(file_name)
        Shell.instance.run("#{@cmd} #{file_name}")
      end
    end
  end
end
