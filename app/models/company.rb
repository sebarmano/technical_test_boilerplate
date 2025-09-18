class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_one_attached :logo
  has_rich_text :description

  validates :name, presence: true
end
