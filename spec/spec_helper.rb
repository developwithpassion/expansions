require 'rspec'
require 'fileutils'
require 'developwithpassion_fakes'

Dir.chdir(File.join(File.dirname(__FILE__),"..,lib".split(','))) do
  Dir.glob("**/*.rb").each do |file| 
    full_path = File.expand_path(file)
    $:.unshift File.expand_path(File.dirname(full_path))
    require full_path
  end
end

class RelativeFileSystem
  class << self
    def base_path
      path = File.join(File.expand_path(File.dirname(__FILE__)),"spec_filesytem")

      return path
    end

    def file_name(name)
      item = File.join(base_path,name)
      return item
    end
  end

  def initialize
    @files = []
    FileUtils.mkdir_p(RelativeFileSystem.base_path)
  end


  def teardown
    FileUtils.rm_rf(RelativeFileSystem.base_path)
  end

  def write_file(name,contents)
    FileUtils.mkdir_p File.dirname(RelativeFileSystem.file_name(name))
    File.open(RelativeFileSystem.file_name(name),'w') do |file|
      file << contents      
    end
  end
end

def fake
  DevelopWithPassion::Fakes::Fake.new
end

def catch_exception
  begin
    yield
  rescue Exception => e
    exception = e
  end
  exception
end

module RSpec
  Matchers.define :have_received do|symbol,*args|
    match do|fake|
      fake.received(symbol).called_with(*args) != nil
    end
  end

  Matchers.define :never_receive do|symbol,*args|
    match do|fake|
      item = fake.received(symbol)
      result = true
      if (item == nil)
        result = (args.count == 0)
      else
        result = (item.called_with(*args) == nil)
      end
      result
    end
  end
end
