class Photo < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :albums
  mount_uploader :image, ImageUploader

  # Like associations
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  validates :title, presence: true, length: { maximum: 140 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :sharing_mode, presence: true, inclusion: { in: %w[public private] }
  validates :image, presence: true
  validate :image_size_validation
  
  def album
    albums.first
  end
  
  private
  
  def image_size_validation
    if image.present? && image.size > 5.megabytes
      errors.add(:image, "should be less than 5MB")
    end
  end

  scope :public_photos, -> { where(sharing_mode: 'public') }
  scope :private_photos, -> { where(sharing_mode: 'private') }
end
