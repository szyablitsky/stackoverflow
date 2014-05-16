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
Message.create!(body: 'Question with answers body', answer: false, topic: topic, author: user)
(1..3).each do |n|
  Message.create!(body: "Answer #{n}", answer: true, topic: topic, author: user)
end

topic = Topic.create!(title: 'Question without answers')
Message.create!(body: 'Question without answers body', answer: false, topic: topic, author: user)
