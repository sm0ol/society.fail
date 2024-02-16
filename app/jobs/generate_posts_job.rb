class GeneratePostsJob < ApplicationJob
  queue_as :default

  def perform
    users = User.order(Arel.sql('RANDOM()')).limit((User.count / 10.0).ceil)

    # Loop through each user and create 1 post for each
    users.each do |user|
      WritePostJob.perform_later(user.id)
    end
  end
end
