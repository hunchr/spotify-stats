# frozen_string_literal: true

class Podcast < ApplicationRecord
  has_many :episodes, dependent: :destroy
  has_many :plays, through: :episodes

  validates :name, presence: true, uniqueness: true
end
