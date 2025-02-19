# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.boolean :completed, null: false, default: false
      t.timestamps
    end
  end
end
