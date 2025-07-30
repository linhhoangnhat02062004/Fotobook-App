class CreateAlbums < ActiveRecord::Migration[8.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :sharing_mode

      t.timestamps
    end
  end
end
