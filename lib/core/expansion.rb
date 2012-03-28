module Expansions
  class Expansion
    attr_accessor :copies,:files_to_merge,:globber

    def initialize
      initialize_hashes :files_to_merge,:copies

      @globber = lambda{|path| return glob(path)}

      array :cleanup_items do|a| 
        a.readable
        a.process_using :run_cleanup,:call 
      end

      array :setup_items do|a| 
        a.readable
        a.process_using :run_setup_items,:call 
      end

      array :executable_files do|a|
        a.mutator :register_executable
        a.process_using :mark_files_executable,ShellActionAgainstFile.new("chmod +x")
      end

      array :files_with_line_endings_to_fix do|a|
        a.mutator :fix_line_endings_for
        a.process_using :fix_line_endings,ShellActionAgainstFile.new("d2u")
      end

      array :folders_to_purge do|a|
        a.mutator :register_folder_to_purge
        a.process_using :purge_targets,ShellActionAgainstFile.new("rm -rf")
      end
    end

    def copy_to target,&block
      hash_process(target,@copies,lambda{|key| return Copy.new(CopyToTarget.new(key))},&block)
    end

    def merge_to target,&block
      hash_process(target,@files_to_merge,lambda{|key| return FileMerge.new(key)},&block)
    end

    def look_for_templates_in(path)
      @globber.call(path).process_all_items_using(TemplateVisitor.instance)
    end

    def cleanup(&block)
      @cleanup_items << block
    end

    def before(&block)
      @setup_items << block
    end

    def run
      run_setup_items
      purge_targets
      expand_items
      merge_items
      run_cleanup
      fix_line_endings 
      mark_files_executable
    end

    :private
    def hash_process(target,hash,factory,&block)
      symbol = target.to_sym
      hash[symbol] = factory.call(target) unless hash.has_key?(symbol)
      hash[symbol].instance_eval(&block)
    end
    def expand_items
      @copies.process_all_values_using{|copy| copy.run}
    end
    def merge_items
      @files_to_merge.process_all_values_using{|merge| merge.run}
    end
  end
end
