# frozen_string_literal: true

class ArtistsController < ApplicationController
  INDEX_HEADERS = %w[
    name plays_count duration first_played_at last_played_at
  ].freeze

  def index
    @artists = filter INDEX_HEADERS, Artist.joins(songs: :plays)
      .where(plays: { created_at: date_range })
      .select("artists.*," \
              "COUNT(plays.id) AS plays_count," \
              "SUM(plays.ms_played) AS duration," \
              "MIN(plays.created_at) AS first_played_at," \
              "MAX(plays.created_at) AS last_played_at")
      .group(artists: :id)
  end

  def show
    @artist = Artist.find params[:id]
  end

  private

  def filter(attrs, artists)
    sort_and_paginate attrs, if params[:q].present?
      artists.where "artists.name LIKE ?", "#{params[:q]}%"
    else
      artists
    end
  end
end
