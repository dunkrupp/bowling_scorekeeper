# frozen_string_literal: true

class CreateRolls < ActiveRecord::Migration[8.0]
  def change
    create_table :rolls do |t|
      t.references :frame, null: false, foreign_key: true
      t.integer :pins, null: false
      t.timestamps
    end
  end
end
