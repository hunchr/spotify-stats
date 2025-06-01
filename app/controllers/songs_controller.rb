# frozen_string_literal: true

class SongsController < ApplicationController
  FORMAT = { day: "%-d %b %Y", month: "%b %Y", year: "%Y" }.freeze
  SORT = {
    "name" => "asc", "artist_name" => "asc", "plays_count" => "desc",
    "first_played_at" => "asc", "last_played_at" => "desc"
  }.freeze

  before_action :redirect_invalid_params, only: %i[index]
  helper_attr :page_offset

  def index
    @songs = Song.joins(:artist, :plays)
      .where(plays: { created_at: date_range })
      .select("songs.*, artists.name as artist_name," \
              "COUNT(plays.id) as plays_count," \
              "MIN(plays.created_at) as first_played_at," \
              "MAX(plays.created_at) as last_played_at")
      .group(songs: :id).order(params[:sort] => params[:dir])
      .limit(params[:limit].to_i).offset page_offset
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

  private

  def most_plays_in(fmt)
    @song.plays
      .select("STRFTIME('#{fmt}', created_at) as date, COUNT(*) as plays_count")
      .group(:date).order(plays_count: :desc).first
  end

  def date_range
    params[:after].to_date.beginning_of_day..params[:before].to_date.end_of_day
  end

  def page_offset
    params[:limit].to_i * params[:page].to_i.pred
  end

  def redirect_invalid_params
    first = Play.order(created_at: :asc).first.created_at.to_date
    last = Play.order(created_at: :desc).first.created_at.to_date
    after = params[:after]&.to_date
    before = params[:before]&.to_date

    song_params = {
      after: fallback(:after, first, after&.>=(first)),
      before: fallback(:before, last, before&.<=(last) && after&.<(before)),
      sort: fallback(:sort, :last_played_at, SORT.key?(params[:sort])),
      dir: fallback(:dir, :desc, SORT.value?(params[:dir])),
      page: fallback(:page, 1, (1..999).cover?(params[:page].to_i)),
      limit: fallback(:limit, 200, (1..).cover?(params[:limit].to_i)),
    }

    redirect_to songs_path song_params if @error
  end

  def fallback(param, default, valid)
    if valid
      params[param]
    else
      @error = true
      default
    end
  end
end
