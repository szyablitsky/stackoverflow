class Tag < ActiveRecord::Base
  has_many :topic_tags
  has_many :topics, through: :topic_tags

  validates :name, presence: true

  default_scope { order topic_tags_count: :desc, name: :asc }
end
