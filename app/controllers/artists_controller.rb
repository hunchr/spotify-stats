# frozen_string_literal: true

class ArtistsController < ApplicationController
  INDEX = %w[name plays_count duration first_played_at last_played_at].freeze

  def index
    artists = Artist.joins(:plays)
      .select("artists.*," \
              "COUNT(plays.id) AS plays_count," \
              "SUM(plays.ms_played) AS duration," \
              "MIN(plays.created_at) AS first_played_at," \
              "MAX(plays.created_at) AS last_played_at")
      .where(filter_date).group(artists: :id).to_sql

    render_table INDEX, Artist.select("*").from("(#{artists}) AS artists")
  end

  STREAK = %w[name streak_length start_date end_date].freeze

  def streak
    artists = Artist.joins(:plays)
      .select("artists.*, DATE(plays.created_at) AS listen_date")
      .where(filter_date).group(:listen_date, artists: :id).to_sql
    artists = Artist
      .select("*, ROW_NUMBER() OVER (PARTITION BY id ORDER BY listen_date) AS rn")
      .from("(#{artists})").to_sql
    artists = Artist
      .select("*, DATE(listen_date, '-' || rn || ' days') AS streak")
      .from("(#{artists})").to_sql
    artists = Artist
      .select("*, COUNT(*) AS streak_length," \
              "MIN(listen_date) AS start_date," \
              "MAX(listen_date) AS end_date")
      .from("(#{artists})").group(:id, :streak).to_sql

    render_table STREAK, Artist.select("*").from("(#{artists}) AS artists")
  end

  def show
    @artist = Artist.find params[:id]
  end
end
