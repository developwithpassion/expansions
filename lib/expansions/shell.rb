module Expansions
  class Shell
    def run(cmd)
      return `#{cmd}`
    end
  end
end
