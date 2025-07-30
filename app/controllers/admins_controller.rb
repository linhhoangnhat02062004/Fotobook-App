class AdminController < ApplicationController
    before_action :authenticate_admin!
  
    def manage_users
      @users = User.all
    end
  
    def manage_photos
      @photos = Photo.all
    end
  
    def manage_albums
      @albums = Album.all
    end
  end
  