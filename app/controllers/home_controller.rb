# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @plays_count = Play.count
    return redirect_to new_import_path if @plays_count.zero?

    @paths = [
      songs_path, song_path(1), on_repeat_songs_path, new_import_path
    ]
  end
end
