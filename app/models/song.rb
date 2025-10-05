# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :artist
  has_many :plays, dependent: :destroy

  validates :uri, :title, presence: true

  def url
    "https://open.spotify.com/track/#{uri}"
  end
end
