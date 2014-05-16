# cleanup

Message.delete_all
Topic.delete_all
User.delete_all

# seeds

User.create!(
  name: 'test_user',
  email: 'user@example.com',
  password: '12345678')

topic = Topic.create!(title: '1st question')
Message.create!(body: 'Question body', answer: false, topic: topic)
(1..3).each do |n|
  Message.create!(body: "Answer #{n}", answer: true, topic: topic)
end
