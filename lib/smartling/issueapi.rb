require 'smartling/api'

module Smartling

  class Issue < Api

    def initialize(args = {})
      super(args)
      @projectId = args[:projectId]
    end

    # Get Issue States - /issues-api/v2/dictionary/issue-states (GET)
    def issue_states(params = nil)
      uri = uri("/issues-api/v2/dictionary/issue-states", params)
      return get(uri)
    end

    # Find Issues - /issues-api/v2/projects/{projectId}/issues/list (POST)
    def list(body = {}, params = nil)
      uri = uri("issues-api/v2/projects/#{@projectId}/issues/list", params)
      return post(uri, body)
    end

    # Count Issues - /issues-api/v2/projects/{projectId}/issues/count (POST)
    def count(body = {}, params = nil)
      uri = uri("issues-api/v2/projects/#{@projectId}/issues/count", params)
      return post(uri, body)
    end

    # Get Issue Details - /issues-api/v2/projects/{projectId}/issues/{issueUid} (GET)
    def issue_details(issueUid, params = nil)
      uri = uri("issues-api/v2/projects/#{@projectId}/issues/#{issueUid}", params)
      return get(uri)
    end

  end
end
