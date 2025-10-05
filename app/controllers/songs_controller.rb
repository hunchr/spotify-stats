# frozen_string_literal: true

class SongsController < ApplicationController
  INDEX = %w[title artist_name plays_count duration first_played_at last_played_at].freeze

  def index
    sql = <<-SQL.squish
      SELECT s.*, a.name AS artist_name,
        COUNT(p.id) AS plays_count,
        SUM(p.ms_played) AS duration,
        MIN(p.created_at) AS first_played_at,
        MAX(p.created_at) AS last_played_at
      FROM songs s
      INNER JOIN artists a ON a.id = s.artist_id
      INNER JOIN song_plays p ON p.song_id = s.id
      #{where_date}
      GROUP BY s.id
    SQL

    render_table INDEX, Song.select("*").from("(#{sql}) AS songs")
  end

  PER_DAY = %w[title artist_name plays_count duration date].freeze

  def per_day
    sql = <<-SQL.squish
      SELECT s.*,
        a.name AS artist_name,
        COUNT(p.id) AS plays_count,
        SUM(p.ms_played) AS duration,
        DATE(p.created_at) AS date
      FROM songs s
      INNER JOIN artists a ON a.id = s.artist_id
      INNER JOIN song_plays p ON p.song_id = s.id
      #{where_date}
      GROUP BY date, s.id
    SQL

    render_table PER_DAY, Song.select("*").from("(#{sql}) AS songs")
  end

  def show
    @song = Song.find params[:id]
    @plays = @song.plays.order :created_at
    @most_plays = ActiveRecord::Base.connection.execute(
      <<-SQL.squish,
      SELECT *
      FROM (#{most_plays_in "day", "%Y-%m-%d"})
      CROSS JOIN (#{most_plays_in "month", "%Y-%m-01"})
      CROSS JOIN (#{most_plays_in "year", "%Y-01-01"})
    SQL
    ).first
    @spotify_info = spotify.get_song @song.uri
    @vocadb_info = VocaDB.get_song @song.title
  end

  private

  def most_plays_in(time, fmt)
    @song.plays
      .select("STRFTIME('#{fmt}', created_at) AS #{time}, COUNT(*) AS #{time}_count")
      .group(time).order("#{time}_count": :desc).limit(1).to_sql
  end
end
