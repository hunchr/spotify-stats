# frozen_string_literal: true

class CreateModels < ActiveRecord::Migration[8.0]
  def change
    create_artists
    create_songs
    create_plays
  end

  private

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

  def create_plays
    create_table :plays do |t|
      t.integer :ms_played, null: false
      t.references :song, null: false, foreign_key: true
      t.datetime :created_at, null: false, precision: 0, index: true
    end
  end
end
