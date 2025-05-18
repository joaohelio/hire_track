class Job < ApplicationRecord
  has_many :applications
  has_many :events, as: :eventable
end
