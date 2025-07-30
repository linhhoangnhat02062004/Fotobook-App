class AlbumsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_album, only: [:show, :edit, :update, :destroy, :like, :unlike]

  def index
    @albums = current_user.albums.includes(:photos)
  end

  def show
    @photos = @album.photos
  end

  def new
    @album = current_user.albums.build
  end

  def create
    @album = current_user.albums.build(album_params)
    
    # Handle image uploads
    if params[:album][:images].present?
      params[:album][:images].each do |image|
        photo = current_user.photos.build(
          title: "Photo from #{@album.title}",
          description: "Uploaded to album: #{@album.title}",
          sharing_mode: @album.sharing_mode,
          image: image
        )
        
        if photo.save
          @album.photos << photo
        else
          @album.errors.add(:base, "Failed to upload image: #{photo.errors.full_messages.join(', ')}")
        end
      end
    end
    
    if @album.errors.empty? && @album.save
      redirect_to @album, notice: 'Album was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Handle image uploads
    if params[:album][:images].present?
      params[:album][:images].each do |image|
        photo = current_user.photos.build(
          title: "Photo from #{@album.title}",
          description: "Uploaded to album: #{@album.title}",
          sharing_mode: @album.sharing_mode,
          image: image
        )
        
        if photo.save
          @album.photos << photo
        else
          @album.errors.add(:base, "Failed to upload image: #{photo.errors.full_messages.join(', ')}")
        end
      end
    end
    
    if @album.errors.empty? && @album.update(album_params)
      redirect_to @album, notice: 'Album was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy
    redirect_to albums_url, notice: 'Album was successfully deleted.'
  end

  def like
    # TODO: Implement like logic
    # current_user.like(@album)
    redirect_back(fallback_location: album_path(@album), notice: 'Album liked!')
  end

  def unlike
    # TODO: Implement unlike logic
    # current_user.unlike(@album)
    redirect_back(fallback_location: album_path(@album), notice: 'Album unliked!')
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :description, :sharing_mode, photo_ids: [])
  end
end
