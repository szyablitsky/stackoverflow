class AddTopicsCounterToTag < ActiveRecord::Migration
  def up
    add_column :tags, :topic_tags_count, :integer, default: 0, null: false

    Tag.find_each do |t|
      Tag.reset_counters(t.id, :topic_tags)
    end
  end

  def down
    remove_column :tags, :topic_tags_count
  end
end
