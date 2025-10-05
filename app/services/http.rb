# frozen_string_literal: true

class Http
  class << self
    def url(url, params)
      uri = URI url
      uri.query = params.map do |key, value|
        "#{key}=#{value.is_a?(Array) ? value.join(",") : value}"
      end.join "&"
      uri
    end

    def get(uri, headers)
      cached = ApiLogs.find_by method: "GET", url: uri.to_s, response_code: 200
      JSON.parse(cached&.response_body || request(:Get, uri, headers))
    end

    def post(uri, headers)
      JSON.parse request :Post, uri, headers
    end

    private

    def request(method, uri, headers)
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      request = Net::HTTP.const_get(method).new uri, headers
      response = http.request request
      body = response.body.force_encoding Encoding::UTF_8

      ApiLogs.create! method: method.to_s.upcase, url: uri.to_s,
        response_code: response.code, response_body: body

      unless response.code == "200"
        Rails.logger.debug response
        response.error!
      end

      body
    end
  end
end
