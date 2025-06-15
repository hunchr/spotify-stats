# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :plays, through: :songs

  validates :name, presence: true, uniqueness: true
end
