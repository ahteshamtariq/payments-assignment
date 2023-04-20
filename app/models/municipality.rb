class Municipality < ApplicationRecord
  belongs_to :package
  has_many :prices

  validates :name, presence: true, uniqueness: true
  validates :price_cents, presence: true
end
