class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc).limit(50)
  end

  def show
    @user = User.find_by(username: params[:username])
  end

  def new
    @user = User.new
  end

  def create
    # Combine location, hobbies, favorite_movies, favorite_music, and favorite_books into a single bio field as a JSON object.
    bio_content = {
      location: params[:user][:location],
      hobbies: params[:user][:hobbies],
      personality: params[:user][:personality]
    }

    @user = User.new(user_params.merge(bio: bio_content.to_json, creator_ip: request.remote_ip))
    if @user.save
      GenerateUserJob.perform_now(@user.id)

      @user = User.find(@user.id)
      
      redirect_to user_profile_path(@user.username), notice: 'Application successfully submitted!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:bio)
  end
end
