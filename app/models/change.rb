class Change < ActiveRecord::Base
  CHANGE_TYPES  = [:advance, :waiting, :finished].freeze

  belongs_to :ticket
end
