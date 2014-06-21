class AddScoreToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :score, :integer, default: 0, null: false
  end
end
