module DevelopWithPassion
  module Expander
    class Copy
      def initialize(copy_target)
        array :sources do|a|
          a.read_and_write
          a.mutator :folder do|item|
            register(item,true)
          end
          a.mutator :contents do|item|
            register(item,false)
          end
          a.mutator :all_contents_in do|set_of_folders|
            set_of_folders.each{|item| contents(item)}
          end
          a.mutator :all_folders_in do|set_of_folders|
            set_of_folders.each{|item| folder(item)}
          end
          a.process_using :run, copy_target
        end
      end

      :private
      def register(folder,copy_containing_folder = false)
        @sources.push(copy_containing_folder ? folder : File.join(folder,'.'))
      end
    end
  end
end
