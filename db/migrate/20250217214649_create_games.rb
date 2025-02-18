# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.boolean :completed
      t.timestamps
    end
  end
end
