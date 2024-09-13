class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  has_many :owned_checklists,
           class_name: "Checklist",
           foreign_key: "owner_id",
           dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collaborated_checklists,
           through: :collaborations,
           source: :checklist

  def save_with_picture
    self.picture = "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=200&d=identicon"
    save
  end
end
