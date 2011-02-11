module TicketsHelper
  def flag_image(ticket)
    case ticket.status
      when 'pending'
        image_tag('icons/flag_red.png')
      when 'active'
        image_tag('icons/flag_yellow.png')
      when 'finished'
        image_tag('icons/flag_green.png')
    end
  end
  
  def corresponding_to_path(ticket)
    Ticket::CORRESPONDING_MAP.each_pair do |key, arr|
      index = arr.index(ticket.corresponding_to.to_sym)
      return "#{key} >> #{arr[index]}" if index
    end
    ticket.corresponding_to
  end
end
