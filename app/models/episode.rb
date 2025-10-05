# frozen_string_literal: true

class Episode < ApplicationRecord
  belongs_to :podcase
  has_many :plays, class_name: :EpisodePlay, dependent: :destroy

  validates :uri, :title, presence: true
end
