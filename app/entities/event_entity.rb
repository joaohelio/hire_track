# frozen_string_literal: true

class EventEntity < Dry::Struct
  attribute :id, Types::Strict::Integer
  attribute :status, Types::Strict::String.optional
end
