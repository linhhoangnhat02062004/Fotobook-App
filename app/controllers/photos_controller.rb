class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :like, :unlike]

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
    redirect_to user_path(current_user), notice: 'Photo was successfully deleted.'
  end

  def like
    # TODO: Implement like logic
    # current_user.like(@photo)
    redirect_back(fallback_location: photo_path(@photo), notice: 'Photo liked!')
  end

  def unlike
    # TODO: Implement unlike logic
    # current_user.unlike(@photo)
    redirect_back(fallback_location: photo_path(@photo), notice: 'Photo unliked!')
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :image, :sharing_mode)
  end
end
  