# frozen_string_literal: true

COLUMNS = {
  artist_name: { as: :string, dir: :asc },
  date: { dir: :desc },
  duration: { dir: :desc },
  end_date: { dir: :desc },
  first_played_at: { dir: :asc },
  last_played_at: { dir: :desc },
  name: { as: :string, dir: :asc },
  plays_count: { as: :number, dir: :desc },
  start_date: { dir: :asc },
  streak_length: { as: :number, dir: :desc },
  title: { as: :string, dir: :asc },
}.stringify_keys.freeze

DIRS = %w[asc desc].freeze
LIMIT = 200

Rails.application.config.after_initialize do
  Rails.application.config.x.date_range = begin
    Range.new(*DIRS.map { SongPlay.order(created_at: it).first&.created_at })
  rescue ActiveRecord::StatementInvalid
    nil..nil
  end
end
