# frozen_string_literal: true

class Spotify::Song
  def initialize(bearer)
    @bearer = bearer
  end

  # https://developer.spotify.com/documentation/web-api/reference/get-track
  def find(id)
    Spotify::Api.get @bearer, "/tracks/#{id}"
  end
end
