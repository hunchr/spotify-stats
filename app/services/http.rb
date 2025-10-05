# frozen_string_literal: true

class Http
  class << self
    def url(uri, params)
      uri = URI uri
      uri.query = params.map do |key, value|
        "#{key}=#{value.is_a?(Array) ? value.join(",") : value}"
      end.join "&"
      uri
    end

    def get(uri, headers)
      request :Get, uri, headers
    end

    def post(uri, headers)
      request :Post, uri, headers
    end

    private

    def request(method, uri, headers)
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      request = Net::HTTP.const_get(method).new uri, headers
      response = http.request request
      body = response.body.force_encoding Encoding::UTF_8

      body = JSON.parse body
      response.error! unless response.code == "200"
      body
    end
  end
end
