# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :page_offset

  private

  def render_table(column_names, collection)
    column_name = column_names.include?(params[:sort]) ? params[:sort] : column_names.last
    dir = DIRS.include?(params[:dir]) ? params[:dir] : DEFAULT_DIRS[column_name.to_sym]

    render "shared/table", locals: {
      collection: collection.order(column_name => dir).limit(LIMIT).offset(page_offset),
    }
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
