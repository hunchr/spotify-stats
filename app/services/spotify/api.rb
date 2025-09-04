# frozen_string_literal: true

require "net/http"

class Spotify::Api
  class << self
    def build(uri, params)
      uri = URI uri
      uri.query = params.map do |key, value|
        "#{key}=#{value.is_a?(Array) ? value.join(",") : value}"
      end.join "&"
      uri
    end

    def get(auth, path, params = {})
      request :Get, auth, path, params
    end

    def post(auth, path, params)
      request :Post, auth, path, params
    end

    private

    def request(method, authorization, path, params)
      uri = build(path[0] == "/" ? "https://api.spotify.com/v1#{path}" : path, params)
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      request = Net::HTTP.const_get(method).new uri, { authorization: }
      response = http.request request
      body = JSON.parse response.body

      Rails.logger.info body
      response.error! unless response.code == "200"
      body
    end
  end
end
