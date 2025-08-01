class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :like, :unlike]
  layout 'photo_show', only: [:show]

  def index
    @photos = current_user.photos.includes(:albums)
  end

  def show
  end

  def new
    @photo = current_user.photos.build
  end

  def create
    @photo = current_user.photos.build(photo_params)
    
    if @photo.save
      redirect_to user_path(current_user), notice: 'Photo was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @photo.update(photo_params)
      redirect_to user_path(current_user), notice: 'Photo was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @photo.destroy
    if current_user.admin?
      redirect_to admin_photos_path, notice: 'Photo was successfully deleted.'
    else
      redirect_to user_path(current_user), notice: 'Photo was successfully deleted.'
    end
  end

  def like
    if user_signed_in?
      current_user.like(@photo)
      redirect_back(fallback_location: photo_path(@photo), notice: 'Photo liked!')
    else
      redirect_back(fallback_location: photo_path(@photo), alert: 'Please sign in to like photos')
    end
  end

  def unlike
    if user_signed_in?
      current_user.unlike(@photo)
      redirect_back(fallback_location: photo_path(@photo), notice: 'Photo unliked!')
    else
      redirect_back(fallback_location: photo_path(@photo), alert: 'Please sign in to unlike photos')
    end
  end

  private

  def set_photo
    @photo = Photo.includes(:user, :albums).find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :image, :sharing_mode)
  end
end
  