class Application < ApplicationRecord
  belongs_to :job
  has_many :events, as: :eventable
end
