# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :artist
  has_many :plays, class_name: :SongPlay, dependent: :destroy

  validates :uri, :title, presence: true
end
