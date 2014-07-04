class AddMessagesCounterToTopic < ActiveRecord::Migration
  def up
    add_column :topics, :messages_count, :integer, default: 0, null: false

    Topic.find_each do |m|
      Topic.reset_counters(m.id, :messages)
    end
  end

  def down
    remove_column :topics, :messages_count
  end
end
