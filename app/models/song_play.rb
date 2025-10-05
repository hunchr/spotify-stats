# frozen_string_literal: true

class SongPlay < ApplicationRecord
  belongs_to :song

  validates :ms_played, presence: true
end
