class AddTopicIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, :topic_id
  end
end
