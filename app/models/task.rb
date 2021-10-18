class Task < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :title, presence: true
end
