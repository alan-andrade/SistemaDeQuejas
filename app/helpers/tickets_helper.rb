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
    path  =   Ticket::CORRESPONDING_MAP.each_pair do |key, values|
                if values.include? ticket.corresponding_to.to_sym
                  return "#{t key.to_s} >> #{t values.find{|v| v == ticket.corresponding_to.to_sym} }"                
                end
              end
  end
end
