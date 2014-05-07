# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

topic = Topic.create!(title:'1st question')

Message.create!(body: 'Question body', answer: false, topic: topic)

(1..5).each do |n|
  Message.create!(body:"Answer #{n}",answer:true,topic:topic)
end

User.create!(email: 't@test.com', password: '12345678', password: '12345678')
