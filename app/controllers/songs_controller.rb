# frozen_string_literal: true

class SongsController < ApplicationController
  FORMAT = { day: "%-d %b %Y", month: "%b %Y", year: "%Y" }.freeze
  DIRS = %w[asc desc].freeze
  DEFAULT_DIR = {
    "name" => "asc", "artist_name" => "asc", "plays_count" => "desc",
    "first_played_at" => "asc", "last_played_at" => "desc", "date" => "desc"
  }.freeze
  LIMIT = 200

  helper_attr :page_offset

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
    @most_plays = {
      day: most_plays_in("%Y-%m-%d"),
      month: most_plays_in("%Y-%m-01"),
      year: most_plays_in("%Y-01-01"),
    }
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

  def most_plays_in(fmt)
    @song.plays
      .select("STRFTIME('#{fmt}', created_at) AS date, COUNT(*) AS plays_count")
      .group(:date).order(plays_count: :desc).first
  end

  def date_range
    params[:since]&.to_time..params[:until]&.to_date&.end_of_day
  rescue StandardError
    ..nil
  end

  def filter(headers, songs)
    sort = headers.include?(params[:sort]) ? params[:sort] : headers.last
    dir = DIRS.include?(params[:dir]) ? params[:dir] : DEFAULT_DIR[sort]

    if params[:q].present?
      songs = songs.where "songs.name LIKE ?", "#{params[:q]}%"
    end
    if params[:artist_name].present?
      songs = songs.where "artists.name LIKE ?", "#{params[:artist_name]}%"
    end

    songs.order(sort => dir).limit(LIMIT).offset page_offset
  end

  def page_offset
    @page_offset ||= begin
      page = params[:page].to_i
      page < 1 ? 0 : page.pred * LIMIT
    end
  end
end
