require 'test_helper'

class ChangeTest < ActiveSupport::TestCase
  test 'inclusion_of_change_type' do
    ticket  = tickets(:one)
    change  = ticket.changes.build(:change_type=>"missed")
    assert(!change.save, "Won't accept change types out of range")
  end
end
