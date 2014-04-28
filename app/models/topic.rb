class Topic < ActiveRecord::Base
  validates :title, presence: true
end
