json.message_id @comment.message.id
json.(@comment, :body)

json.author do
  json.name @comment.author.name
  json.url user_path(@comment.author)
end

json.time do
  json.iso @comment.created_at
  json.human @comment.created_at.to_formatted_s(:rfc822)
end
