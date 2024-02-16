class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc).limit(50)
  end

  def show
    @post = Post.find(params[:id])
  end
end
