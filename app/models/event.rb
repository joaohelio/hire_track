class Event < ApplicationRecord
  belongs_to :job, optional: true
  belongs_to :application, optional: true
  belongs_to :eventable, polymorphic: true
end
