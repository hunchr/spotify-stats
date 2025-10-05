# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :page_offset

  SPOTIFY_SCOPES = %w[user-library-read user-follow-read].freeze

  def spotify
    Spotify.connect session[:spotify_auth], SPOTIFY_SCOPES do |refreshed_auth, url|
      session[:spotify_auth] = refreshed_auth
      redirect_to url, allow_other_host: true if url
    end
  end

  private

  def render_table(column_names, collection)
    render "shared/table", locals: {
      column_names:, search_fields: filter_collection!(column_names, collection),
      collection: sort_collection(column_names, collection).limit(LIMIT).offset(page_offset)
    }
  end

  def sort_collection(column_names, collection)
    column_name = params[:sort]&.presence_in(column_names) || column_names.last
    dir = params[:dir]&.presence_in(DIRS) || COLUMNS[column_name][:dir]
    collection.order column_name => dir
  end

  def filter_collection!(column_names, collection)
    column_names.select do |column_name|
      type = COLUMNS[column_name][:as]
      next if type.nil?

      value = params[column_name]
      next true if value.blank?

      if type == :string
        collection.where! "#{column_name} LIKE ?", "#{value}%"
      else
        value = value.split("..", 2).map { it.presence&.to_i }
        collection.where! column_name => value.length == 1 ? value[0] : Range.new(*value)
      end
    end
  end

  def where_date
    from = params[:since]&.to_date
    to = params[:until]&.to_date&.tomorrow

    if from && to then " WHERE p.created_at BETWEEN '#{from}' AND '#{to}'"
    elsif from then " WHERE p.created_at >= '#{from}'"
    elsif to then " WHERE p.created_at <= '#{to}'"
    end
  rescue Date::Error
    nil
  end

  def page_offset
    @page_offset ||= begin
      page = params[:page].to_i
      page < 1 ? 0 : page.pred * LIMIT
    end
  end
end
