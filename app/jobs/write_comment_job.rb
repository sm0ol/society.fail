class WriteCommentJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    # Exclude the post's author and select a random user to make the comment
    user = User.where.not(id: post.user_id).order(Arel.sql('RANDOM()')).first

    client = OpenAI::Client.new(access_token: ENV['OPENAI'])

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo-0125",
        messages: [
          { 
            role: "user", content: <<-ASSISTANT.strip_heredoc,
              Here's the post you are commenting on:
              Title: "#{post.title}"
              Body: "#{post.body}"  

              Here is information about you: "#{user.bio}"

              Write a comment based on the post and your information. Limit it to no more than 300 characters. Do not include hashtags or links.

              Always respond in JSON format, with the following structure:

              {
              "body": ""
              }
            ASSISTANT
          },
        ],
        response_format: { type: "json_object" },
        temperature: 1.25,
        max_tokens: 300
      })

    response_content = JSON.parse(response.dig("choices", 0, "message", "content"))

    post.comments.create(
      user_id: user.id,
      body: response_content["body"]
    )
  end
end
