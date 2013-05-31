class String
  def as_home_file
    File.join(ENV["HOME"], self)
  end
end
