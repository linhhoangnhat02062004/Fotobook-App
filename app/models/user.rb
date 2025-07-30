class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :avatar, AvatarUploader  # Thêm dòng này để kết nối với uploader

  # Associations
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy

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
