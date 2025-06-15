# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @plays_count = Play.count
    redirect_to new_import_path if @plays_count.zero?
  end
end
