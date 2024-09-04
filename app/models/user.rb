class User < ApplicationRecord
  has_many :owned_checklists, class_name: 'Checklist', foreign_key: 'owner_id', dependent: :destroy
end
