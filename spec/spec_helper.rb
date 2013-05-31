require 'rspec'
require 'fileutils'
require 'fakes'
require 'fakes-rspec'

Dir.chdir(File.join(File.dirname(__FILE__),"..,lib".split(','))) do
  require 'expansions.rb'
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

def catch_exception
  begin
    yield
  rescue Exception => e
    exception = e
  end
  exception
end

