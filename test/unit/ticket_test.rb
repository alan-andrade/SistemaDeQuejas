require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "ticket_saved_with_student_id" do
    ticket  = Ticket.new()
    assert !ticket.save
  end
  
  test 'ticket_status_not_nil' do
    ticket  = Ticket.create(:student_id=>232323)
    ticket.save
    assert !ticket.status.nil?, 'El status de la queja es nulo!. Debe ser \'pending\''
  end
  
  test 'ticket_status_change_after_responsible_changes' do
    ticket  = tickets(:one)
    ticket.responsible_id = 3333
    ticket.save
    assert (ticket.status == :active), 'El status de la queja no cambia correctamente'
  end
end
