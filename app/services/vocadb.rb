# frozen_string_literal: true

class VocaDB
  @user_agent = ENV.fetch "VOCADB_USER_AGENT", nil

  class << self
    attr_reader :user_agent

    # https://vocadb.net/swagger/index.html#operations-SongApi-get_api_songs
    def get_song(title)
      uri = Http.uri "https://vocadb.net/api/songs", fields: "Tags", maxResults: 1,
        query: URI::RFC2396_PARSER.escape(title), songTypes: "Original", sort: "FavoritedTimes"
      song = request(:get, uri)&.dig "items", 0
      return if song.nil?

      sort_tags! song
      song
    end

    private

    def request(method, uri)
      return if @user_agent.blank?

      Http.public_send method, uri, { "user-agent" => @user_agent }
    end

    def sort_tags!(song)
      song["genres"] = []
      song["themes"] = []
      song["tags"].sort { |a, b| b["count"] - a["count"] }.each do |tag|
        case tag["tag"]["categoryName"]
        when "Genres" then song["genres"] << tag["tag"]["name"]
        when "Themes" then song["themes"] << tag["tag"]["name"]
        end
      end
    end
  end
end
