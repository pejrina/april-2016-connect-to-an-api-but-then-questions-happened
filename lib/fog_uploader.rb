# This is a simple fog uploader to store an IO object in the cloud
#
# Configuration for a Rails app should happen in an initializer

require 'fog'
require 'open-uri'

class FogUploader

  class InitializeError < RuntimeError; end
  class OpenError < RuntimeError; end
  class UploadError < RuntimeError; end

  attr_accessor :connection, :directory_name, :directory

  def initialize(options={})
    self.directory_name = options.delete(:directory)
    self.connection = ::Fog::Storage.new(
      options
      )
    self.directory = get_directory_create_if_necessary(directory_name)
  rescue => e
    raise InitializeError.new "#{e.class}: #{e}"
  end

  def upload_stream(io_object, remote_name)
    io_object.rewind
    directory.files.create(
      key: remote_name,
      body: io_object,
      public: true
      )
  rescue => e
    raise UploadError.new "#{e.class}: #{e}"
  end

  def upload(name, remote_name)
    Kernel.open(name) do |io|
      upload_stream(io, remote_name)
    end
  rescue => e
    raise OpenError.new "#{e.class} #{e}"
  end

  private

  def get_directory_create_if_necessary(name)
    dir = connection.directories.get(name)
    if dir.nil?
      dir = connection.directories.create(
        key: name,
        public: true
        )
    end
    dir
  end
end
