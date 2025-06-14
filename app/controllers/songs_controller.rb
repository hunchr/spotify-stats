# frozen_string_literal: true

class SongsController < ApplicationController
  INDEX_HEADERS = %w[
    name artist_name plays_count first_played_at last_played_at
  ].freeze

  def index
    @songs = filter INDEX_HEADERS, Song.joins(:artist, :plays)
      .where(plays: { created_at: date_range })
      .select("songs.*, artists.name AS artist_name," \
              "COUNT(plays.id) AS plays_count," \
              "MIN(plays.created_at) AS first_played_at," \
              "MAX(plays.created_at) AS last_played_at")
      .group(songs: :id)
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

  ON_REPEAT_HEADERS = %w[name artist_name plays_count date].freeze

  def on_repeat
    subquery = Play.joins(:song).where(created_at: date_range)
      .select("songs.*, DATE(plays.created_at) AS date,COUNT(*) AS plays_count")
      .group(:date, songs: :id).to_sql

    @songs = filter ON_REPEAT_HEADERS,
      Song.joins(:artist).select("songs.*, artists.name AS artist_name")
        .from("(#{subquery}) AS songs").where(plays_count: 5..)
  end

  private

  def most_plays_in(time, fmt)
    @song.plays
      .select("STRFTIME('#{fmt}', created_at) AS #{time}," \
              "COUNT(*) AS #{time}_count")
      .group(time).order("#{time}_count": :desc).limit(1).to_sql
  end

  def filter(attrs, songs)
    if params[:q].present?
      songs = songs.where "songs.name LIKE ?", "#{params[:q]}%"
    end
    if params[:artist_name].present?
      songs = songs.where "artists.name LIKE ?", "#{params[:artist_name]}%"
    end

    sort_and_paginate attrs, songs
  end
end
