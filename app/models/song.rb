# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :artist
  has_many :plays, dependent: :destroy

  validates :title, presence: true
end
