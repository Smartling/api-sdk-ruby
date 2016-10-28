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

  class File < Api

    def initialize(args = {})
      super(args)
      @prefix = 'files-api/v2/projects/' + args[:projectId] + '/'
    end

    # List Files - /files-api/v2/projects/{projectId}/files/list (GET)
    def list(params = nil)
      uri = uri('file', params)
      return get(uri.to_s)
    end

    # List File Types - /files-api/v2/projects/{projectId}/file-types (GET)
    def list_types(params = nil)
      uri = uri('file-types', params)
      return get(uri.to_s)
    end

    # Status - All Locales - /files-api/v2/projects/{projectId}/file/status (GET)
    def status(name)
      keys = { :fileUri => name }
      uri = uri('file/status', keys, {}).require(:fileUri)
      return get(uri.to_s)
    end

    # Status - Single Locale / Extended Response - /files-api/v2/projects/{projectId}/locales/{localeId}/file/status (GET)
    def status(name, locale)
      keys = { :fileUri => name }
      uri = uri('locales/' + locale + '/file/status', keys, {}).require(:fileUri)
      return get(uri.to_s)
    end

    # Download Original File - /files-api/v2/projects/{projectId}/file (GET)
    def download(name, params = nil)
      keys = { :fileUri => name }
      uri = uri('file', keys, params).require(:fileUri)
      return get_raw(uri.to_s)
    end

    # Download Translated File - Single Locale - /files-api/v2/projects/{projectId}/locales/{localeId}/file (GET)
    def download_translated(name, locale, params = nil)
      keys = { :fileUri => name }
      uri = uri('locales/' + locale + '/file', keys, params).require(:fileUri)
      return get_raw(uri.to_s)
    end

    # Download Translated Files - Multiple Locales as .ZIP - /files-api/v2/projects/{projectId}/files/zip (GET)
    def download_translated_zip(names, params = nil)
      keys = { :fileUris => names, :localeIds => locales }
      uri = uri('files/zip', keys, params).require(:fileUris, :localeIds)
      return get_raw(uri.to_s)
    end

    # Download Translated File - All Locales as .ZIP - /files-api/v2/projects/{projectId}/locales/all/file/zip (GET)
    def download_all_translated_zip(name, params = nil)
      keys = { :fileUri => name }
      uri = uri('locales/all/file/zip', keys, params).require(:fileUri)
      return get_raw(uri.to_s)
    end

    # Download Translated File - All Locales in one File - CSV - /files-api/v2/projects/{projectId}/locales/all/file (GET)
    def download_all_translated_csv(name, params = nil)
      keys = { :fileUri => name }
      uri = uri('locales/all/file', keys, params).require(:fileUri)
      return get_raw(uri.to_s)
    end

    # Upload File - /files-api/v2/projects/{projectId}/file (POST)
    def upload(file, name, type, params = nil)
      keys = { :fileUri => name, :fileType => type }
      uri = uri('file', keys, params).require(:fileUri, :fileType)
      file = ::File.open(file, 'rb') if file.is_a?(String)
      return post(uri.to_s, :file => file)
    end

    # Rename - /files-api/v2/projects/{projectId}/file/rename (POST)
    def rename(name, newname, params = nil)
      keys = { :fileUri => name, :newFileUri => newname }
      uri = uri('file/rename', keys, params).require(:fileUri, :newFileUri)
      return post(uri.to_s)
    end

    # Delete - /files-api/v2/projects/{projectId}/file/delete (POST)
    def delete(name, params = nil)
      keys = { :fileUri => name }
      uri = uri('file/delete', keys, params).require(:fileUri)
      return post(uri.to_s)
    end

    # Last Modified (by locale) - /files-api/v2/projects/{projectId}/locales/{localeId}/file/last-modified (GET)
    def last_modified(name, locale, params = nil)
      keys = { :fileUri => name }
      uri = uri('locales/' + locale +'/file/last-modified', keys, params).require(:fileUri)
      return get(uri.to_s)
    end

    # Last Modified (all locales) - /files-api/v2/projects/{projectId}/file/last-modified (GET)
    def last_modified(name, params = nil)
      keys = { :fileUri => name }
      uri = uri('file/last-modified', keys, params).require(:fileUri)
      return get(uri.to_s)
    end
    
    # Get Translations - /files-api/v2/projects/{projectId}/locales/{localeId}/file/get-translations (POST)
    def download_translated(locale, file, fileUri, params = nil)
      keys = { :fileUri => fileUri }
      uri = uri('locales/' + locale + '/file/get-translations', keys, params).require(:fileUri)
      return get_raw(uri.to_s, :file => file)
    end

    # Import Translations - /files-api/v2/projects/{projectId}/locales/{localeId}/file/import (POST or PUT)
    def import(locale, file, name, type, state, params = nil)
        keys = { :fileUri => name, :fileType => type, :translationState => state}
        uri = uri('locales/' + locale +'/file/import', keys, params).require(:fileUri, :fileType, :translationState)
        file = ::File.open(file, 'rb') if file.is_a?(String)
        return post(uri.to_s, :file => file)
    end
  end

end

