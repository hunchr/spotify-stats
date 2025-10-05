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
      COLUMNS[column_name][:dir]
    end

    url_for(**params.to_unsafe_h, sort: column_name, dir:)
  end

  def td_artist_name(r)
    tag.td link_to(r["artist_name"], artist_path(r["artist_id"])), class: "max-w-12"
  end

  def td_date(r)
    tag.td r["date"], class: "text-right"
  end

  def td_duration(r)
    tag.td duration_in_words(r["duration"]), class: "text-right"
  end

  def td_end_date(r)
    tag.td r["end_date"], class: "text-right"
  end

  def td_first_played_at(r)
    tag.td r["first_played_at"][..9], class: "text-right"
  end

  def td_last_played_at(r)
    tag.td r["last_played_at"][..9], class: "text-right"
  end

  def td_name(r)
    if r.is_a? Podcast
      tag.td link_to r["name"], podcast_path(r["id"])
    else
      tag.td link_to(r["name"], artist_path(r["id"])), class: "max-w-12"
    end
  end

  def td_plays_count(r)
    tag.td r["plays_count"], class: "text-right"
  end

  def td_start_date(r)
    tag.td r["start_date"], class: "text-right"
  end

  def td_streak_length(r)
    tag.td r["streak_length"], class: "text-right"
  end

  def td_title(r)
    tag.td link_to r["title"], song_path(r["id"])
  end
end
