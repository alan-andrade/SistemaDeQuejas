pdf.image open("http://ser.udlap.mx/imagenes/logoUDLA.jpg")

pdf.text "Reporte de Quejas", :size=> 20, :style=>:bold, :align=>:center

for ticket in @tickets
  pdf.text ticket.student.name, :size=>15, :decoration=>:underline
  pdf.text ticket.title
  pdf.text ticket.description
  pdf.move_down(10)
  pdf.text "Archivos"
  for attachment in ticket.attachments
    pdf.text attachment.file_name
  end  
  pdf.start_new_page
end
