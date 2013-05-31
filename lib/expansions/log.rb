module Expansions
  class Log
    class << self
      def message(item)
        puts item if @enabled
      end
      def enable
        @enabled = true
      end
      def disable
        @enabled = false
      end
    end
  end
end
