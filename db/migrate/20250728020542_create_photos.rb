class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :sharing_mode
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
