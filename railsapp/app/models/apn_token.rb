class ApnToken < ApplicationRecord
  validates :token, uniqueness: true
end
