# frozen_string_literal: true

class EpisodePlay < ApplicationRecord
  belongs_to :episode

  validates :ms_played, presence: true
end
