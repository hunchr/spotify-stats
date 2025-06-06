# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
