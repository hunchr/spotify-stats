# frozen_string_literal: true

class Spotify
  @client_id = ENV.fetch "SPOTIFY_CLIENT_ID", nil
  @client_secret = ENV.fetch "SPOTIFY_CLIENT_SECRET", nil
  @redirect_uri = ENV.fetch "SPOTIFY_REDIRECT_URI", nil

  class << self
    attr_reader :client_id, :client_secret, :redirect_uri

    def authorize(code)
      Rails.logger.info "Authorizing Spotify"
      get_token code:, grant_type: :authorization_code, redirect_uri:
    end

    def authorize_url(scopes)
      Http.uri "https://accounts.spotify.com/authorize",
        client_id:, redirect_uri:, response_type: :code,
        scope: scopes.join("%20"), state: SecureRandom.hex(8)
    end

    def connect(session, scopes, &)
      return new if client_id.blank?

      if session.nil?
        yield nil, authorize_url(scopes)
        return new
      elsif session["expires_in"] < Time.zone.now.to_i
        Rails.logger.info "Refreshing Spotify token"
        session = get_token grant_type: :refresh_token, refresh_token: session["refresh_token"]
        yield session
      end

      new session["access_token"]
    end

    private

    def get_token(params)
      res = Http.post Http.uri("https://accounts.spotify.com/api/token", params),
        authorization: "Basic #{Base64.strict_encode64 "#{client_id}:#{client_secret}"}"

      {
        "access_token" => res["access_token"], "refresh_token" => res["refresh_token"],
        "expires_in" => res["expires_in"].seconds.from_now.to_i, "scope" => res["scope"].split
      }
    end
  end

  def initialize(access_token = nil)
    @access_token = access_token
  end

  # https://developer.spotify.com/documentation/web-api/reference/get-track
  def get_song(id)
    request :get, "https://api.spotify.com/v1/tracks/#{id}"
  end

  private

  def request(method, url)
    return if @access_token.nil?

    Http.public_send method, URI(url), { authorization: "Bearer #{@access_token}" }
  end
end
