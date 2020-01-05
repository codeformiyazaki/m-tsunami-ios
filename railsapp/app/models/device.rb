class Device < ApplicationRecord
  validates :name, presence: true
  scope :active, -> { where(active: true) }

  def token
    id.to_s.crypt("mtsunami")
  end
end
