class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @total_users = User.count
    @total_photos = Photo.count
    @total_albums = Album.count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_photos = Photo.includes(:user).order(created_at: :desc).limit(5)
    @recent_albums = Album.includes(:user).order(created_at: :desc).limit(5)
  end

  private

  def ensure_admin
    unless current_user.email == 'admin@example.com'
      redirect_to root_path, alert: 'Access denied. Admin only.'
    end
  end
end 