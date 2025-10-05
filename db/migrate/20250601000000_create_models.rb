# frozen_string_literal: true

class CreateModels < ActiveRecord::Migration[8.0]
  def change
    create_api_logs
    create_artists
    create_songs
    create_song_plays
    create_podcasts
    create_episodes
    create_episode_plays
  end

  private

  def create_api_logs
    create_table :api_logs do |t|
      t.string :method, null: false
      t.string :url, null: false
      t.integer :response_code
      t.text :response_body
      t.datetime :created_at, null: false, precision: 0
    end
  end

  def create_artists
    create_table :artists do |t|
      t.string :name, null: false, index: { unique: true }
    end
  end

  def create_songs
    create_table :songs do |t|
      t.string :uri, null: false
      t.string :title, null: false, index: true
      t.references :artist, null: false, foreign_key: true
    end
  end

  def create_song_plays
    create_table :song_plays do |t|
      t.integer :ms_played, null: false
      t.references :song, null: false, foreign_key: true
      t.datetime :created_at, null: false, precision: 0, index: true
    end
  end

  def create_podcasts
    create_table :podcasts do |t|
      t.string :name, null: false, index: { unique: true }
    end
  end

  def create_episodes
    create_table :episodes do |t|
      t.string :uri, null: false
      t.string :title, null: false, index: true
      t.references :podcast, null: false, foreign_key: true
    end
  end

  def create_episode_plays
    create_table :episode_plays do |t|
      t.integer :ms_played, null: false
      t.references :episode, null: false, foreign_key: true
      t.datetime :created_at, null: false, precision: 0, index: true
    end
  end
end
