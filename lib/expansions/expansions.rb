module Expansions
  extend self

  def expand(title = "Expansion",&block)
    Expansions::Expansion.instance.instance_eval(&block)
  end

  def glob(path, exclude=->(file) { false })
    items = Dir.glob(path, File::FNM_DOTMATCH)
    items.each{|item| yield item if block_given? && !exclude.call(item)}
    return items
  end

  def configure(configuration_hash)
    configatron.configure_from_hash(configuration_hash)
  end

  def settings
    configatron
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
