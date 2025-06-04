# frozen_string_literal: true

class SongsController < ApplicationController
  FORMAT = { day: "%-d %b %Y", month: "%b %Y", year: "%Y" }.freeze
  DIRS = %w[asc desc].freeze
  DEFAULT_DIR = {
    "name" => "asc", "artist_name" => "asc", "plays_count" => "desc",
    "first_played_at" => "asc", "last_played_at" => "desc", "date" => "desc"
  }.freeze
  INDEX_HEADERS = %w[
    name artist_name plays_count first_played_at last_played_at
  ].freeze
  ON_REPEAT_HEADERS = %w[name artist_name plays_count date].freeze
  LIMIT = 200

  helper_attr :page_offset

  def index
    @songs = sort_and_limit INDEX_HEADERS, Song.joins(:artist, :plays)
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
    @most_plays = {
      day: most_plays_in("%Y-%m-%d"),
      month: most_plays_in("%Y-%m-01"),
      year: most_plays_in("%Y-01-01"),
    }
  end

  def on_repeat
    subquery = Play.joins(:song, song: :artist)
      .select("songs.*, artists.name AS artist_name," \
              "DATE(plays.created_at) AS date, COUNT(*) AS plays_count")
      .group(:date, songs: :id).to_sql

    @songs = sort_and_limit ON_REPEAT_HEADERS,
      Song.from("(#{subquery}) AS songs").where(plays_count: 5..)
  end

  private

  def most_plays_in(fmt)
    @song.plays
      .select("STRFTIME('#{fmt}', created_at) AS date, COUNT(*) AS plays_count")
      .group(:date).order(plays_count: :desc).first
  end

  def date_range
    params[:after]&.to_time..params[:before]&.to_date&.end_of_day
  rescue StandardError
    ..nil
  end

  def sort_and_limit(sort, songs)
    key = sort.include?(params[:sort]) ? params[:sort] : sort.last
    dir = DIRS.include?(params[:dir]) ? params[:dir] : DEFAULT_DIR[key]

    songs.order(key => dir).limit(LIMIT).offset page_offset
  end

  def page_offset
    @page_offset ||= begin
      page = params[:page].to_i
      page < 1 ? 0 : page.pred * LIMIT
    end
  end
end
