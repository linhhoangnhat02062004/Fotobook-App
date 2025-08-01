class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :avatar, AvatarUploader  # Thêm dòng này để kết nối với uploader

  # Associations
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy

  # Following/follower associations
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  def following?(other_user)
    followings.include?(other_user)
  end

  def follower?(other_user)
    followers.include?(other_user)
  end

  def following_ids
    followings.pluck(:id)
  end

  # Like associations
  has_many :likes, dependent: :destroy
  has_many :liked_photos, through: :likes, source: :likeable, source_type: 'Photo'
  has_many :liked_albums, through: :likes, source: :likeable, source_type: 'Album'

  def liked?(likeable)
    likes.exists?(likeable: likeable)
  end

  def like(likeable)
    likes.create(likeable: likeable) unless liked?(likeable)
  end

  def unlike(likeable)
    likes.find_by(likeable: likeable)&.destroy
  end

  # Admin methods
  def admin?
    admin == true
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def status_text
    case status
    when 'active'
      'Active'
    when 'suspended'
      'Suspended'
    when 'banned'
      'Banned'
    else
      'Active'
    end
  end

  def status_badge_class
    case status
    when 'active'
      'badge-success'
    when 'suspended'
      'badge-warning'
    when 'banned'
      'badge-danger'
    else
      'badge-success'
    end
  end
end
