module Expansions
  class CLIInterface
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
      Startup.run
      log "Running Expansions defined in file:#{file_to_run}"
      load file_to_run
      Expansion.instance.run
    end
  end
end
