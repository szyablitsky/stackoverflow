# cleanup

Message.delete_all
Topic.delete_all
User.delete_all

# seeds

user = User.create!(
  name: 'test_user',
  email: 'user@example.com',
  password: '12345678')

topic = Topic.create!(title: 'Question with answers')
Message.create!(body: Forgery(:lorem_ipsum).paragraphs, answer: false, topic: topic, author: user)
(1..3).each do |n|
  Message.create!(body: Forgery(:lorem_ipsum).paragraphs, answer: true, topic: topic, author: user)
end

topic = Topic.create!(title: 'Question without answers')
Message.create!(body: Forgery(:lorem_ipsum).paragraphs, answer: false, topic: topic, author: user)
