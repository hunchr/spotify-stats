# frozen_string_literal: true

class ArtistsController < ApplicationController
  INDEX = %w[name plays_count duration first_played_at last_played_at].freeze

  def index
    sql = <<-SQL.squish
      SELECT a.*,
        COUNT(p.id) AS plays_count,
        SUM(p.ms_played) AS duration,
        MIN(p.created_at) AS first_played_at,
        MAX(p.created_at) AS last_played_at
      FROM artists a
      INNER JOIN songs s ON s.artist_id = a.id
      INNER JOIN song_plays p ON p.song_id = s.id
      #{where_date}
      GROUP BY a.id
    SQL

    render_table INDEX, Artist.select("*").from("(#{sql}) AS artists")
  end

  STREAK = %w[name streak_length start_date end_date].freeze

  def streak
    sql = <<-SQL.squish
      SELECT *,
        COUNT(*) AS streak_length,
        MIN(listen_date) AS start_date,
        MAX(listen_date) AS end_date
      FROM (
        SELECT *, DATE(listen_date, '-' || rn || ' days') AS streak
        FROM (
          SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY listen_date) AS rn
          FROM (
            SELECT a.*, DATE(p.created_at) AS listen_date
            FROM artists a
            INNER JOIN songs s ON s.artist_id = a.id
            INNER JOIN song_plays p ON p.song_id = s.id
            #{where_date}
            GROUP BY listen_date, a.id
          )
        )
      )
      GROUP BY id, streak
    SQL

    render_table STREAK, Artist.select("*").from("(#{sql}) AS artists")
  end

  def show
    @artist = Artist.find params[:id]
  end
end
