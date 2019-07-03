class Timeline < ApplicationRecord
  has_many :track
  has_many :moment
end
