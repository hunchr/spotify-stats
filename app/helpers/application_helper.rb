# frozen_string_literal: true

module ApplicationHelper
  DATE_FORMAT = { "day" => "%-d %b %Y", "month" => "%b %Y", "year" => "%Y" }.freeze

  def format_date(string)
    string.to_date.strftime "%-d %b %Y"
  end

  def format_time(time)
    time.strftime "%Y-%m-%d %H:%M"
  end

  def format_duration(ms)
    min = ms / 60_000

    [min, (ms / 1000) - (min * 60)].map { it.to_s.rjust(2, "0") }.join ":"
  end

  def duration_in_words(ms)
    s = ms / 1000

    case ms
    when (86_400_000..)
      h = (s % 86_400) / 3600
      "#{s / 86_400}d#{" #{h}h" if h.nonzero?}"
    when (3_600_000..)
      min = (s % 3600) / 60
      "#{s / 3600}h#{" #{min}min" if min.nonzero?}"
    when (60_000..)
      "#{s / 60}min"
    else
      "#{s}s"
    end
  end

  def sort_path(column_name)
    dir = if params[:sort] == column_name
      params[:dir] == "asc" ? :desc : :asc
    else
      DEFAULT_DIRS[column_name.to_sym]
    end

    url_for(**params.to_unsafe_h, sort: column_name, dir:)
  end

  def td_artist_name(resource)
    tag.td link_to(resource[:artist_name], artist_path(resource[:artist_id])), class: "max-w-12"
  end

  def td_date(resource)
    tag.td resource[:date], class: "text-right"
  end

  def td_first_played_at(resource)
    tag.td resource[:first_played_at][..9], class: "text-right"
  end

  def td_last_played_at(resource)
    tag.td resource[:last_played_at][..9], class: "text-right"
  end

  def td_name(resource)
    tag.td link_to(resource[:name], artist_path(resource[:id])), class: "max-w-12"
  end

  def td_plays_count(resource)
    tag.td resource[:plays_count], class: "text-right"
  end

  def td_plays_length(resource)
    tag.td duration_in_words(resource[:plays_length]), class: "text-right"
  end

  def td_title(resource)
    tag.td link_to resource[:title], song_path(resource[:id])
  end
end
