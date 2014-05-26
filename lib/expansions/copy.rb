module Expansions
  class Copy
    include ArrayFu

    array :sources do 
      read_and_write

      mutator :folder do |item| 
        register(item,true) 
      end

      mutator :contents do |item| 
        register(item, false) 
      end

      mutator :all_contents_in do |set_of_folders| 
        set_of_folders.each do |item| 
          contents(item)
        end
      end

      mutator :all_folders_in do |set_of_folders| 
        set_of_folders.each do |item| 
          folder(item)
        end
      end
    end

    def initialize(copy_target)
      array :sources do
        process_using :run, copy_target
      end
      super
    end

    def register(folder, copy_containing_folder=false)
      @sources.push(copy_containing_folder ? folder : File.join(folder,'.'))
    end
  end
end
