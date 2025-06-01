# frozen_string_literal: true

class ImportsController < ApplicationController
  def create
    history = params["history"]
    return if history.empty?

    history.each { JSON.parse(it.read).each { create_play it } }
  end

  private

  def create_play(entry)
    Artist.find_or_create_by!(name: entry["master_metadata_album_artist_name"])
      .songs.find_or_create_by!(name: entry["master_metadata_track_name"])
      .plays.create! ms_played: entry["ms_played"], created_at: entry["ts"]
  rescue ActiveRecord::RecordInvalid
    nil
  end
end
