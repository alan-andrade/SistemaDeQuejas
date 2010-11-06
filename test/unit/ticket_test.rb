require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "ticket_saved_with_student_id" do
    ticket  = Ticket.new(:student_id=>34123)
    assert ticket.save
  end
end
