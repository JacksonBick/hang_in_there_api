class Poster < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price, numericality: true
  validates :year, numericality: { only_integer: true }
  validates :vintage, inclusion: { in: [true, false] }
  validates :img_url, presence: true
end
