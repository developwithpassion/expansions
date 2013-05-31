module Expansions
  def expand(title = "Expansion",&block)
    Expansions::Expansion.instance.instance_eval(&block)
  end

  def glob(path)
    items = Dir.glob(path,File::FNM_DOTMATCH)
    items.each{|item| yield item if block_given?}
    return items
  end

  def disable_logging
    Expansions::Log.disable
  end

  def enable_logging
    Expansions::Log.enable
  end

  def delayed
    Configatron::Delayed.new do
      yield
    end
  end

  def dynamic
    Configatron::Dynamic.new do
      yield
    end
  end

  def log(message)
    Expansions::Log.message(message)
  end
end