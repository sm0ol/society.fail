class GenerateUserJob < ApplicationJob
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
              Here's a little bit about you: "#{user.bio}"

              Always respond in JSON format, with the following structure:

              {
              "username": "" // Make it unique. Max 16 characters. Alpha-numerics, dashes, and underscores only. Do not use the word "test" or "user".
              "full_fictious_name": ""
              "location": "",
              "bio": "", // Be creative.
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

    user.update(
      username: response_content["username"],
      name: response_content["full_fictious_name"],
      location: response_content["location"],
      bio: response_content["bio"],
      joined_at: Time.current
    )
  end
end
