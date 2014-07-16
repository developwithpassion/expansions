class Array
  def as_home_files
    self.map{|item| item.as_home_file}
  end

  def as_glob_pattern
    File.join(self)
  end
end
