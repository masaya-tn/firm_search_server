class Firm < ApplicationRecord
  has_many :performances, dependent: :destroy
end