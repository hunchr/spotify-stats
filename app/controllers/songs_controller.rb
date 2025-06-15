# frozen_string_literal: true

class SongsController < ApplicationController
  INDEX = %w[title artist_name plays_count plays_length first_played_at last_played_at].freeze

  def index
    songs = Song.joins(:artist, :plays)
      .select("songs.*, artists.name AS artist_name," \
              "COUNT(plays.id) AS plays_count," \
              "SUM(plays.ms_played) AS plays_length," \
              "MIN(plays.created_at) AS first_played_at," \
              "MAX(plays.created_at) AS last_played_at")
      .where(plays: { created_at: date_range })
      .group(songs: :id).to_sql

    render_table INDEX, Song.select("*").from("(#{songs}) AS songs")
  end

  PER_DAY = %w[title artist_name plays_count plays_length date].freeze

  def per_day
    songs = Song.joins(:artist, :plays)
      .select("songs.*, artists.name AS artist_name," \
              "COUNT(plays.id) AS plays_count," \
              "SUM(plays.ms_played) AS plays_length," \
              "DATE(plays.created_at) AS date")
      .where(plays: { created_at: date_range })
      .group(:date, songs: :id).to_sql

    render_table PER_DAY, Song.select("*").from("(#{songs}) AS songs")
  end

  def show
    @song = Song.find params[:id]
    @plays = @song.plays.order :created_at
    @most_plays = ActiveRecord::Base.connection.execute(
      "SELECT * FROM (#{most_plays_in "day", "%Y-%m-%d"}) " \
      "CROSS JOIN (#{most_plays_in "month", "%Y-%m-01"}) " \
      "CROSS JOIN (#{most_plays_in "year", "%Y-01-01"})",
    ).first
  end

  private

  def most_plays_in(time, fmt)
    @song.plays
      .select("STRFTIME('#{fmt}', created_at) AS #{time}, COUNT(*) AS #{time}_count")
      .group(time).order("#{time}_count": :desc).limit(1).to_sql
  end
end
