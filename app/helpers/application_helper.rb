# frozen_string_literal: true

module ApplicationHelper
  def format_time(time)
    time.strftime "%Y-%m-%d %H:%M"
  end

  def format_date(string)
    string.to_date.strftime "%-d %b %Y"
  end

  def format_duration(ms)
    min = ms / 60_000

    [min, (ms / 1000) - (min * 60)].map { it.to_s.rjust(2, "0") }.join ":"
  end

  def format_duration_in_words(ms)
    s = ms / 1000
    min = s / 60

    case ms
    when 3_600_000.. then "#{min / 60}h #{min - (min / 60 * 60)}min"
    when 60_000..3_599_999 then "#{min}min #{s - (min * 60)}s"
    when 1000..59_999 then "#{s}s"
    else "#{ms}ms"
    end
  end

  def songs_path_sort(sort, dir)
    dir = params[:dir] == "asc" ? "desc" : "asc" if params[:sort] == sort

    songs_path params.permit(:after, :before, :sort, :dir, :page, :limit)
      .merge sort:, dir:
  end
end
