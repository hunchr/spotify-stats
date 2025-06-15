# frozen_string_literal: true

class ArtistsController < ApplicationController
  INDEX = %w[name plays_count plays_length first_played_at last_played_at].freeze

  def index
    render_table INDEX, Artist.joins(:plays)
      .select("artists.*," \
              "COUNT(plays.id) AS plays_count," \
              "SUM(plays.ms_played) AS plays_length," \
              "MIN(plays.created_at) AS first_played_at," \
              "MAX(plays.created_at) AS last_played_at")
      .where(plays: { created_at: date_range })
      .group(artists: :id)
  end

  def show
    @artist = Artist.find params[:id]
  end

  # private

  # def filter(attrs, artists)
  #   sort_and_paginate attrs, if params[:q].present?
  #     artists.where "artists.name LIKE ?", "#{params[:q]}%"
  #   else
  #     artists
  #   end
  # end
end
