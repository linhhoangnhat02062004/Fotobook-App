class FeedsController < ApplicationController
  before_action :redirect_admin_to_dashboard

  def index
    if user_signed_in?
      # Show following content for logged in users
      following_ids = current_user.following_ids
      @photos = Photo.joins(:user)
                     .where(users: { id: following_ids })
                     .where(sharing_mode: 'public')
                     .includes(:user, :albums)
                     .order(created_at: :desc)
                     .limit(20)
      
      @albums = Album.joins(:user)
                     .where(users: { id: following_ids })
                     .where(sharing_mode: 'public')
                     .includes(:user, :photos)
                     .order(created_at: :desc)
                     .limit(20)
    else
      # Show all public content for guests
      @photos = Photo.where(sharing_mode: 'public').includes(:user, :albums).order(created_at: :desc).limit(20)
      @albums = Album.where(sharing_mode: 'public').includes(:user, :photos).order(created_at: :desc).limit(20)
    end
  end

  def discover
    # Discover page - show all public content
    @photos = Photo.where(sharing_mode: 'public').includes(:user, :albums).order(created_at: :desc).page(params[:page]).per(20)
    @albums = Album.where(sharing_mode: 'public').includes(:user, :photos).order(created_at: :desc).page(params[:page]).per(20)
  end

  def discovery
    @photos = Photo.where(sharing_mode: 'public').includes(:user).order(created_at: :desc)
    @albums = Album.where(sharing_mode: 'public').includes(:user, :photos).order(created_at: :desc)
  end

  def search
    query = params[:q]
    if query.present?
      @photos = Photo.where(sharing_mode: 'public')
                     .where('title ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%")
                     .includes(:user)
                     .order(created_at: :desc)
      
      @albums = Album.where(sharing_mode: 'public')
                     .where('title ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%")
                     .includes(:user, :photos)
                     .order(created_at: :desc)
    else
      @photos = Photo.none
      @albums = Album.none
    end
  end

  private

  def redirect_admin_to_dashboard
    if user_signed_in? && current_user.admin?
      redirect_to admin_dashboard_path
    end
  end
end
  