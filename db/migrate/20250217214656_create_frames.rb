# frozen_string_literal: true

class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.references :game, null: false, foreign_key: true
      t.timestamps
      t.boolean :completed, null: false, default: false
      t.integer :frame_number, null: false
      t.integer :score, null: false
      t.string :type, null: false
    end
  end
end
