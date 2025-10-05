# frozen_string_literal: true

class PodcastsController < ApplicationController
  INDEX = %w[name plays_count duration first_played_at last_played_at].freeze

  def index
    sql = <<-SQL.squish
      SELECT c.*,
        COUNT(p.id) AS plays_count,
        SUM(p.ms_played) AS duration,
        MIN(p.created_at) AS first_played_at,
        MAX(p.created_at) AS last_played_at
      FROM podcasts c
      INNER JOIN episodes e ON e.podcast_id = c.id
      INNER JOIN episode_plays p ON p.episode_id = e.id
      #{where_date}
      GROUP BY c.id
    SQL

    render_table INDEX, Podcast.select("*").from("(#{sql}) AS podcasts")
  end

  def show
    @podcast = Podcast.find params[:id]
  end
end
