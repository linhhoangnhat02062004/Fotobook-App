class Album < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :photos
  mount_uploader :cover_image, ImageUploader

  # Like associations
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  validates :title, presence: true, length: { maximum: 140 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :sharing_mode, presence: true, inclusion: { in: %w[public private] }
  
  # Custom validation for images
  validate :validate_images_count
  
  scope :public_albums, -> { where(sharing_mode: 'public') }
  scope :private_albums, -> { where(sharing_mode: 'private') }

  def photo_count
    photos.count
  end

  def cover_photo
    photos.first
  end
  
  private
  
  def validate_images_count
    if photos.count > 25
      errors.add(:base, "Album cannot have more than 25 images")
    end
  end
end
