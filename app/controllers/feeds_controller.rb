class FeedsController < ApplicationController
  before_action :redirect_admin_to_dashboard

  def index
    # Root path - show feeds for all users
    @photos = Photo.where(sharing_mode: 'public').includes(:user, :albums).order(created_at: :desc).limit(20)
    @albums = Album.where(sharing_mode: 'public').includes(:user, :photos).order(created_at: :desc).limit(20)
    
    # If user is logged in, show following content
    if user_signed_in?
      # TODO: Add following logic when follow system is implemented
      # @following_photos = Photo.joins(:user).where(users: { id: current_user.following_ids }).where(sharing_mode: 'public')
      # @following_albums = Album.joins(:user).where(users: { id: current_user.following_ids }).where(sharing_mode: 'public')
    end
  end

  def discover
    # Discover page - show all public content
    @photos = Photo.where(sharing_mode: 'public').includes(:user, :albums).order(created_at: :desc).page(params[:page]).per(20)
    @albums = Album.where(sharing_mode: 'public').includes(:user, :photos).order(created_at: :desc).page(params[:page]).per(20)
  end

  private

  def redirect_admin_to_dashboard
    if user_signed_in? && current_user.admin?
      redirect_to admin_dashboard_path
    end
  end
end
  