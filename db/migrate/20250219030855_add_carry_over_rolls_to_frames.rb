# frozen_string_literal: true

class AddCarryOverRollsToFrames < ActiveRecord::Migration[8.0]
  def change
    change_table :frames do |t|
      t.integer :carry_over_rolls
    end
  end
end
