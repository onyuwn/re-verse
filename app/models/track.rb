class Track < ApplicationRecord
  belongs_to :timeline
  has_one_attached :image
end
