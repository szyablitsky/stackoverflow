class AddAnswerToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :answer, :boolean
  end
end
