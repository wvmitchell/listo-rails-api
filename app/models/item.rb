class Item < ApplicationRecord
  belongs_to :checklist

  validates :content, presence: true, length: { minimum: 1 }
end
