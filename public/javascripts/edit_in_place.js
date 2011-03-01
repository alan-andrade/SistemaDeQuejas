$(document).ready(function(){
  $('#ticket_responsible').editable(window.location.pathname0 ,{
    name        : "ticket[responsible_id]",
    submitdata: {"_method": 'put'},
    loadurl: '/managers',
    type: 'select',
    tooltip:  'Click para cambiar'})
})
