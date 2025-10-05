# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authorize

  def show
    redirect_to new_import_path if SongPlay.none?
  end

  def stats
    @stats = ActiveRecord::Base.connection.execute(
      <<-SQL.squish,
      SELECT
        (SELECT COUNT(*) FROM artists) AS artists_count,
        (SELECT COUNT(*) FROM songs) AS songs_count,
        (SELECT COUNT(*) FROM song_plays) AS song_plays_count,
        (SELECT SUM(ms_played) FROM song_plays) AS song_plays_duration,
        (SELECT COUNT(*) FROM podcasts) AS podcasts_count,
        (SELECT COUNT(*) FROM episodes) AS episodes_count,
        (SELECT COUNT(*) FROM episode_plays) AS episode_plays_count,
        (SELECT SUM(ms_played) FROM episode_plays) AS episode_plays_duration
    SQL
    ).first
  end

  private

  def authorize
    return if params[:code].blank?

    session[:spotify_auth] = Spotify.authorize params[:code]
    redirect_to root_url
  end
end
