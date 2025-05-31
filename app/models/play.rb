# frozen_string_literal: true

class Play < ApplicationRecord
  belongs_to :song

  validates :ms_played, presence: true
end
