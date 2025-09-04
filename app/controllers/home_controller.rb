# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authorize

  def show
    @plays_count = Play.count
    redirect_to new_import_path if @plays_count.zero?
  end

  private

  def authorize
    return if params[:code].blank?

    session[:auth] = Spotify.authorize params[:code]
    redirect_to root_url
  end
end
