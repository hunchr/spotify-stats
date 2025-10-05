# frozen_string_literal: true

class ApiLogs < ApplicationRecord
  validates :method, :url, presence: true
end
