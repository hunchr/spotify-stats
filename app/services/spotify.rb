# frozen_string_literal: true

class Spotify
  @client_id = ENV.fetch "SPOTIFY_CLIENT_ID", nil
  @client_secret = ENV.fetch "SPOTIFY_CLIENT_SECRET", nil
  @redirect_uri = ENV.fetch "SPOTIFY_REDIRECT_URI", nil

  class << self
    attr_reader :client_id, :client_secret, :redirect_uri

    def authorize_url(scopes)
      Http.url "https://accounts.spotify.com/authorize", {
        client_id:, redirect_uri:, response_type: :code,
        scope: scopes.join("%20"),
        state: SecureRandom.hex(8)
      }
    end

    def authorize(code)
      Rails.logger.info "Authorizing Spotify"
      get_token({ code:, grant_type: :authorization_code, redirect_uri: })
    end

    def refresh_session(refresh_token)
      Rails.logger.info "Refreshing Spotify token"
      get_token({ grant_type: :refresh_token, refresh_token: })
    end

    private

    def get_token(params)
      res = Http.post Http.url("https://accounts.spotify.com/api/token", params),
        { authorization: "Basic #{Base64.strict_encode64 "#{client_id}:#{client_secret}"}" }

      {
        "access_token" => res["access_token"], "refresh_token" => res["refresh_token"],
        "expires_in" => res["expires_in"].seconds.from_now.to_i, "scope" => res["scope"].split
      }
    end
  end

  def initialize(access_token)
    @headers = { authorization: "Bearer #{access_token}" }
  end

  # https://developer.spotify.com/documentation/web-api/reference/get-track
  def get_song(id)
    Http.get URI("https://api.spotify.com/v1/tracks/#{id}"), @headers
  end
end
