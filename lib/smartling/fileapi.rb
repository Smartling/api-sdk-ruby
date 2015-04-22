# Copyright 2012 Smartling, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'smartling/api'

module Smartling

  module Services
    FILE_LIST = 'file/list'
    FILE_STATUS = 'file/status'
    FILE_GET = 'file/get'
    FILE_UPLOAD = 'file/upload'
    FILE_RENAME = 'file/rename'
    FILE_DELETE = 'file/delete'
    FILE_IMPORT = 'file/import'
  end

  class File < Api
    alias :api_delete :delete

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
      file = ::File.open(file, 'rb') if file.is_a?(String)
      return post(uri.to_s, :file => file)
    end

    def rename(name, newname, params = nil)
      keys = { :fileUri => name, :newFileUri => newname }
      uri = uri(Services::FILE_RENAME, keys, params).require(:fileUri, :newFileUri)
      return post(uri.to_s)
    end

    def delete(name, params = nil)
      keys = { :fileUri => name }
      uri = uri(Services::FILE_DELETE, keys, params).require(:fileUri)
      return api_delete(uri.to_s)
    end

    def import(file, name, type, state, params = nil)
        keys = { :fileUri => name, :fileType => type, :translationState => state}
        uri = uri(Services::FILE_IMPORT, keys, params).require(:fileUri, :fileType, :locale, :translationState)
        file = ::File.open(file, 'rb') if file.is_a?(String)
        return post(uri.to_s, :file => file)
    end
  end

end

