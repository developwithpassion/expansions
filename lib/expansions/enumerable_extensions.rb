module Enumerable
  def process_all_items_using(visitor)
    self.each{|item| visitor.run_using(item)}
  end
end

class Hash
  def process_all_values_using(&block)
    self.values.each{|item| yield item}
  end
end
