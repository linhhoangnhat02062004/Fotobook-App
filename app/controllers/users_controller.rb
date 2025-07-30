class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follow, :unfollow]
  before_action :authenticate_user!, only: [:edit, :update, :follow, :unfollow]

  def show
    @photos = @user.photos.includes(:albums)
    @albums = @user.albums.includes(:photos)
    
    # Count stats
    @photos_count = @user.photos.count
    @albums_count = @user.albums.count
    @followings_count = 0 # TODO: Implement when follow system is ready
    @followers_count = 0  # TODO: Implement when follow system is ready
    
    # Check if current user is following this user
    @is_following = false # TODO: Implement when follow system is ready
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def follow
    # TODO: Implement follow logic
    # current_user.follow(@user)
    redirect_back(fallback_location: user_path(@user), notice: 'Followed successfully.')
  end

  def unfollow
    # TODO: Implement unfollow logic
    # current_user.unfollow(@user)
    redirect_back(fallback_location: user_path(@user), notice: 'Unfollowed successfully.')
  end

  private

  def set_user
    if params[:id] == 'current' || params[:id].nil?
      @user = current_user
    elsif params[:id].match?(/\D/) # Nếu id không phải là số (như 'sign_out', 'sign_in', etc.)
      redirect_to root_path, alert: 'Invalid user ID'
    else
      @user = User.find(params[:id])
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar)
  end
end
  