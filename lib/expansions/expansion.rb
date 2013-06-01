module Expansions
  class Expansion
    include ArrayFu
    include ::Expansions

    attr_accessor :copies
    attr_accessor :files_to_merge
    attr_accessor :globber

    array :cleanup_items do
      readable
      process_using :run_cleanup,:call 
    end

    array :setup_items do
      readable
      process_using :run_setup_items,:call 
    end

    array :executable_files do
      readable
      mutator :register_executable
      process_using :mark_files_executable, Expansions::ShellActionAgainstFile.new("chmod +x")
    end

    array :files_with_line_endings_to_fix do 
      readable
      mutator :fix_line_endings_for
      process_using :fix_line_endings, Expansions::ShellActionAgainstFile.new("d2u")
    end

    array :folders_to_purge do 
      readable
      mutator :register_folder_to_purge
      process_using :purge_targets, Expansions::ShellActionAgainstFile.new("rm -rf")
    end

    def initialize
      initialize_hashes :files_to_merge,:copies

      @globber = Proc.new do |path|
        glob(path)
      end

      initialize_arrayfu
    end

    def copy_to(target, &block)
      copy_proc = Proc.new do |key|
        Copy.new(CopyToTarget.new(key))
      end
      hash_process(target, copies, copy_proc, &block)
    end

    def merge_to(target, &block)
      merge_proc = Proc.new do |key|
        FileMerge.new(key)
      end
      hash_process(target, files_to_merge, merge_proc, &block)
    end

    def look_for_templates_in(path)
      globber.call(path).process_all_items_using(TemplateVisitor.instance)
    end

    def cleanup(&block)
      cleanup_items << block
    end

    def before(&block)
      setup_items << block
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

    def hash_process(target,hash,factory,&block)
      symbol = target.to_sym
      hash[symbol] = factory.call(target) unless hash.has_key?(symbol)
      hash[symbol].instance_eval(&block)
    end

    def expand_items
      copies.process_all_values_using do |copy|
        copy.run
      end
    end

    def merge_items
      files_to_merge.process_all_values_using do |merge| 
        merge.run
      end
    end
  end
end
