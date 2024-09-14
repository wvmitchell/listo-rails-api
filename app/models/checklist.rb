class Checklist < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :items, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user

  validates :title, presence: true, length: { minimum: 1 }

  def members
    [ owner ] + collaborators
  end
end
