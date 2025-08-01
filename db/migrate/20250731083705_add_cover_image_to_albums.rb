class AddCoverImageToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :albums, :cover_image, :string
  end
end
