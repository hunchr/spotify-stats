# frozen_string_literal: true

class ApplicationController < ActionController::Base
  DIRS = %w[asc desc].freeze
  DEFAULT_DIR = {
    "name" => "asc", "artist_name" => "asc", "plays_count" => "desc",
    "first_played_at" => "asc", "last_played_at" => "desc", "date" => "desc"
  }.freeze
  LIMIT = 200

  helper_method :page_offset

  private

  def sort_and_paginate(attrs, collection)
    sort = attrs.include?(params[:sort]) ? params[:sort] : attrs.last
    dir = DIRS.include?(params[:dir]) ? params[:dir] : DEFAULT_DIR[sort]

    collection.order(sort => dir).limit(LIMIT).offset page_offset
  end

  def date_range
    params[:since]&.to_time..params[:until]&.to_date&.end_of_day
  rescue StandardError
    ..nil
  end

  def page_offset
    @page_offset ||= begin
      page = params[:page].to_i
      page < 1 ? 0 : page.pred * LIMIT
    end
  end
end
