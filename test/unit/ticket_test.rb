require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "ticket_saved_with_student_id" do
    ticket  = Ticket.new()
    assert !ticket.save
  end
  
  test 'ticket_with_bad_corresponding_to_params' do
    ticket  = Ticket.new(:student_id => 12345,:corresponding_to => "MySelf")
    assert(!ticket.save, "Won't save with params out of bounds")
  end
  
  test 'ticket_status_not_nil' do
    ticket  = Ticket.new(:student_id=>232323,:corresponding_to=>"profesor")
    ticket.save
    assert !ticket.status.nil?, 'El status de la queja es nulo!. Debe ser \'pending\''
  end
  
  test 'ticket_status_change_after_responsible_changes' do
    ticket  = tickets(:one)
    ticket.responsible_id = 3333
    ticket.save
    assert (ticket.status == 'active'), 'El status de la queja no cambia correctamente'
  end
  
  test 'status_to_finished_when_last_change_is_done' do
    ticket  = tickets(:one)  
    ticket.responsible_id = 666;  ticket.save
    change  = ticket.changes.build(:change_type=>'finished')
    change.save
    ticket.reload
    assert ticket.status  ==  Ticket::STATUS.last
  end
end
