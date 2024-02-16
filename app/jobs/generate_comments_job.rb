class GenerateCommentsJob < ApplicationJob
  queue_as :default

  def perform
    posts = Post.order(Arel.sql('RANDOM()')).limit(User.count * 0.2)

    # Loop through each post and create 1 comment for each
    posts.each do |post|
      WriteCommentJob.perform_later(post.id)
    end
  end
end
