# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations
class ImportsController < ApplicationController
  def create
    history = params["history"]
    return if history.empty?

    @artists = {}
    history.each { JSON.parse(it.read).each { add_play it } }
    insert_artists!
    delete_insignificant

    redirect_to root_path
  end

  private

  def add_play(entry)
    return if entry["incognito_mode"] || entry["spotify_track_uri"].nil?

    ((@artists[entry["master_metadata_album_artist_name"]] ||= {}
     )[entry["master_metadata_track_name"]] ||= [entry["spotify_track_uri"][14..], []]
    )[1] << [entry["ms_played"], entry["ts"]]
  end

  def insert_all!(model, values)
    model.insert_all!(values.flatten).rows.map(&:first)
  end

  def insert_artists!
    artist_ids = insert_all!(Artist, @artists.keys.compact.map { { name: it } })
    song_plays = []
    song_ids = insert_all!(Song, @artists.values.each_with_index.map do |songs, i|
      songs.map do |title, (uri, plays)|
        song_plays << plays.map { { ms_played: it[0], created_at: it[1] } }
        { uri:, title:, artist_id: artist_ids[i] }
      end
    end)

    insert_all!(SongPlay, song_plays.each_with_index
      .map { |plays, i| plays.map { { **it, song_id: song_ids[i] } } })
  end

  def delete_insignificant
    SongPlay.where(ms_played: ...1000).delete_all
  end
end
# rubocop:enable Rails/SkipsModelValidations
