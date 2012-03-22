module Kernel
  def expand(title = "Expansion",&block)
    DevelopWithPassion::Expander::Expansion.instance.instance_eval(&block)
  end

  def glob(path)
    items = Dir.glob(path,File::FNM_DOTMATCH)
    items.each{|item| yield item if block_given?}
    return items
  end

  def disable_logging
    DevelopWithPassion::Expander::Log.disable
  end

  def enable_logging
    DevelopWithPassion::Expander::Log.enable
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
    DevelopWithPassion::Expander::Log.message(message)
  end
end
