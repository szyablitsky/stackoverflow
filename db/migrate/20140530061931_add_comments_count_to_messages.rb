class AddCommentsCountToMessages < ActiveRecord::Migration
  def up
    add_column :messages, :comments_count, :integer, default: 0, null: false

    Message.find_each do |m|
      Message.reset_counters(m.id, :comments)
    end
  end

  def down
    remove_column :messages, :comments_count
  end
end
