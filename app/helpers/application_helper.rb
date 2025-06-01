# frozen_string_literal: true

module ApplicationHelper
  def songs_path_sort(sort, dir)
    dir = params[:dir] == "asc" ? "desc" : "asc" if params[:sort] == sort

    songs_path params.permit(:after, :before, :sort, :dir, :page, :limit)
      .merge sort:, dir:
  end
end
