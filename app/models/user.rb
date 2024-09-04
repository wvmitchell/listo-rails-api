class User < ApplicationRecord
  has_many :owned_checklists,
           class_name: "Checklist",
           foreign_key: "owner_id",
           dependent: :destroy

  has_many :collaborations, dependent: :destroy
  has_many :collaborated_checklists,
           through: :collaborations,
           source: :checklist
end
