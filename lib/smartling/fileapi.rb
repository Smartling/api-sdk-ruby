require 'smartling/api'

module Smartling

  module Services
    FILE_LIST = '/file/list'
    FILE_STATUS = '/file/status'
    FILE_GET = '/file/get'
    FILE_UPLOAD = '/file/upload'
  end

  class File < Api
    def list(params = nil)
      uri = uri(Services::FILE_LIST, params)
      return get(uri)
    end

    def status(name, locale, params = nil)
      keys = { :fileUri => name, :locale => locale }
      uri = uri(Services::FILE_STATUS, keys, params)
      return get(uri)
    end

    def download(name, locale = nil, params = nil)
      keys = { :fileUri => name }
      keys[:locale] = locale if locale
      uri = uri(Services::FILE_GET, keys, params)
      return get_raw(uri)
    end

    def upload(file, name, type, params = nil)
      keys = { :fileUri => name, :fileType => type }
      uri = uri(Services::FILE_UPLOAD, keys, params)
      file = ::File.new(file, 'rb') if file.is_a?(String)
      return post(uri, { :file => file })
    end
  end

end

