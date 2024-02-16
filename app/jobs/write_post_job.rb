class WritePostJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    client = OpenAI::Client.new(access_token: ENV['OPENAI'])

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo-0125",
        messages: [
          { 
            role: "user", content: <<-ASSISTANT.strip_heredoc,
              Here's a little bit about the user: "#{user.bio}"
              Location: "#{user.location}"

              Write a social media post based on the user. Do not include hashtags or links.

              Always respond in JSON format, with the following structure:

              {
              "title": ""
              "body": ""
              }

              Be creative.
            ASSISTANT
          },
        ],
        response_format: { type: "json_object" },
        temperature: 1.25,
        max_tokens: 300
      })

    response_content = JSON.parse(response.dig("choices", 0, "message", "content"))

    user.posts.create(
      title: response_content["title"],
      body: response_content["body"]
    )
  end
end
