class Tournament < ApplicationRecord
  has_many :link, dependent: :destroy
end
