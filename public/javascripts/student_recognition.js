$(document).ready(function(){
    var cambiar = $("<a id='switch-field' href='#'>Cambiar</a>");
    var inactiveCss = { 'font-style' :  'italic', 'color'  : '#222' }
    var activeCss   = { 'font-style' :  'normal', 'color'  : 'black'}
    
    $("#switch-field").live('click', function(){
        $('#student-info').hide();
        $('#ticket_student_id').val('')
          .show()
          .select()
    })
    
    $('#ticket_student_id').blur(function(){
        student_id = $('#ticket_student_id').val()
        if (student_id != ''){
            $.get('/users/'+student_id,
                  {},
                  function(data){
                      if (data != null){
                          name        = data.user.name
                          student_id  = data.user.uid
                          $('#ticket_student_id').hide();
                          $('#field-message').hide();
                          $('#student-info').html('<p>' + student_id + ' - ' + name +'</p>').append(cambiar).show();
                      }else{
                          $('#field-message').show().html('No existe el ID');
                          $('#ticket_student_id').val('');
                          $('#ticket_student_id').select();
                      }
                  }, 'json' )
        } else { $(this).val('ID del estudiante').css(inactiveCss) }
    }).ajaxSend(    function(){ $("#spinner").show()  })
    .ajaxComplete(  function(){ $("#spinner").hide()  })    
    .css(inactiveCss)    
    .focus(function(){ $(this).css(activeCss).val('') })
});
