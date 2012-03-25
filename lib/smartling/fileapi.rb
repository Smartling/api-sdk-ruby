require 'smartling/api'

module Smartling

  module Services
    FILE_LIST = 'file/list'
    FILE_STATUS = 'file/status'
    FILE_GET = 'file/get'
    FILE_UPLOAD = 'file/upload'
  end

  class File < Api
    def list(params = nil)
      uri = uri(Services::FILE_LIST, params)
      return get(uri.to_s)
    end

    def status(name, params)
      keys = { :fileUri => name }
      uri = uri(Services::FILE_STATUS, keys, params).require(:fileUri, :locale)
      return get(uri.to_s)
    end

    def download(name, params = nil)
      keys = { :fileUri => name }
      uri = uri(Services::FILE_GET, keys, params).require(:fileUri)
      return get_raw(uri.to_s)
    end

    def upload(file, name, type, params = nil)
      keys = { :fileUri => name, :fileType => type }
      uri = uri(Services::FILE_UPLOAD, keys, params).require(:fileUri, :fileType)
      file = ::File.new(file, 'rb') if file.is_a?(String)
      return post(uri.to_s, :file => file)
    end
  end

end

