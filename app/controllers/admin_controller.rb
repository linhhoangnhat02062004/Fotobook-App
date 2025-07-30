class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_user, only: [:show_user, :update_user, :destroy_user]
  before_action :set_album, only: [:show_album, :update_album, :destroy_album]
  before_action :set_photo, only: [:show_photo, :update_photo, :destroy_photo]

  def dashboard
    @total_users = User.count
    @total_albums = Album.count
    @total_photos = Photo.count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_albums = Album.order(created_at: :desc).limit(5)
    @recent_photos = Photo.order(created_at: :desc).limit(5)
  end

  # Users Management
  def users
    @users = User.includes(:albums, :photos)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(20)
  end

  def show_user
    @user_albums = @user.albums.order(created_at: :desc)
    @user_photos = @user.photos.order(created_at: :desc)
  end

  def update_user
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User updated successfully'
    else
      render :show_user, status: :unprocessable_entity
    end
  end

  def destroy_user
    @user.destroy
    redirect_to admin_users_path, notice: 'User deleted successfully'
  end

  # Albums Management
  def albums
    @albums = Album.includes(:user, :photos)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
  end

  def show_album
    @album_photos = @album.photos.order(created_at: :desc)
  end

  def update_album
    if @album.update(album_params)
      redirect_to admin_album_path(@album), notice: 'Album updated successfully'
    else
      render :show_album, status: :unprocessable_entity
    end
  end

  def destroy_album
    @album.destroy
    redirect_to admin_albums_path, notice: 'Album deleted successfully'
  end

  # Photos Management
  def photos
    @photos = Photo.includes(:user, :album)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20)
  end

  def show_photo
  end

  def update_photo
    if @photo.update(photo_params)
      redirect_to admin_photo_path(@photo), notice: 'Photo updated successfully'
    else
      render :show_photo, status: :unprocessable_entity
    end
  end

  def destroy_photo
    @photo.destroy
    redirect_to admin_photos_path, notice: 'Photo deleted successfully'
  end

  private

  def ensure_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_album
    @album = Album.find(params[:id])
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :admin, :status)
  end

  def album_params
    params.require(:album).permit(:title, :description, :sharing_mode)
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :sharing_mode)
  end
end 