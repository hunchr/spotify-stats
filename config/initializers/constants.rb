# frozen_string_literal: true

DIRS = %w[asc desc].freeze
DEFAULT_DIRS = {
  artist_name: :asc, date: :desc, first_played_at: :asc, last_played_at: :desc,
  plays_count: :desc, plays_length: :desc, title: :asc
}.freeze
LIMIT = 200
