class Checklist < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :items, dependent: :destroy

  validates :title, presence: true, length: { minimum: 1 }
end
