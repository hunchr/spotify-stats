# frozen_string_literal: true

class ImportsController < ApplicationController
  def create
    history = params["history"]
    return if history.empty?

    @data = {}
    history.each { JSON.parse(it.read).each { add_play it } }
    insert_data!
    delete_insignificant

    redirect_to root_path
  end

  private

  def add_play(entry)
    return if entry["incognito_mode"] || entry["spotify_track_uri"].nil?

    ((@data[entry["master_metadata_album_artist_name"]] ||= {})[
      [entry["spotify_track_uri"][14..], entry["master_metadata_track_name"]],
    ] ||= []) << [entry["ms_played"], entry["ts"]]
  end

  def insert_all!(model, values)
    model.insert_all!(values.flatten).rows.map(&:first)
  end

  def insert_data!
    artist_ids = insert_all!(Artist, @data.keys.compact.map { { name: it } })
    song_plays = []
    song_ids = insert_all! Song, (@data.values.each_with_index.map do |songs, i|
      songs.map do |key, plays|
        uri, title = key
        song_plays << plays.map { { ms_played: it[0], created_at: it[1] } }
        { uri:, title:, artist_id: artist_ids[i] }
      end
    end)

    insert_all!(Play, song_plays.each_with_index
      .map { |plays, i| plays.map { { **it, song_id: song_ids[i] } } })
  end

  def delete_insignificant
    Play.where(ms_played: ...1000).delete_all
  end
end
