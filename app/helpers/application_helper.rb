# frozen_string_literal: true

module ApplicationHelper
  DATE_FORMAT = { "day" => "%-d %b %Y", "month" => "%b %Y", "year" => "%Y" }
    .freeze

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

    case ms
    when 86_400_000.. then "#{s / 86_400}d"
    when 3_600_000.. then "#{s / 3600}h #{(s % 3600) / 60}min"
    when 60_000.. then "#{s / 60}min #{s % 60}s"
    when 1_000.. then "#{s}s"
    else "#{ms}ms"
    end
  end

  def sort_path(sort, dir)
    dir = params[:dir] == "asc" ? "desc" : "asc" if params[:sort] == sort

    url_for(**params.to_unsafe_h, sort:, dir:)
  end
end
