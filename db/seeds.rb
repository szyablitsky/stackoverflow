# cleanup

Message.delete_all
Topic.delete_all
User.delete_all

# seeds

user1 = User.create!(
  name: 'user1',
  email: 'user1@example.com',
  password: '12345678',
  reputation: 1000)
user2 = User.create!(
  name: 'user2',
  email: 'user2@example.com',
  password: '12345678',
  reputation: 1)

topic = Topic.create!(title: 'Question with answers')
Message.create!(
  body: Forgery(:lorem_ipsum).paragraphs,
  answer: false,
  topic: topic,
  author: user1)
(1..2).each do |n|
  Message.create!(
    body: Forgery(:lorem_ipsum).paragraphs,
    answer: true,
    topic: topic,
    author: eval("user#{n}"))
end

topic = Topic.create!(title: 'Question without answers')
question = Message.create!(
  body: Forgery(:lorem_ipsum).paragraphs,
  answer: false, topic: topic, author: user2)
(1..2).each do |n|
  Comment.create!(
    body: Forgery(:lorem_ipsum).sentences,
    message: question,
    author: eval("user#{n}"))
end

