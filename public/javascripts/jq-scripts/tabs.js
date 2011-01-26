$(document).ready(function(){
  $("#spinner").bind('ajaxSend', function(){
          $(this).show();
      }).bind('ajaxComplete',function(){
          $(this).hide();});
          
  $("#tabs").tabs({
			ajaxOptions: {
				  error: function( xhr, status, index, anchor ) {
					  $( anchor.hash ).html(
						  "Tenemos un error en el servidor. En verdad sentimos los problemas que esto le causa. Estamos trabajando para arreglarlos los antes posible");
				  },
				  success: function(){
				        $.each( $('input:checkbox[id]=ticket_to_report'), function(index, cb){
                    if(cookie_defined('tickets_to_report')==true){
                      values  = $.cookie('tickets_to_report').split(' ');
                      if ($.inArray(cb.value, values) != -1 ){
                        cb.checked = true;};};
                }); 				  
				  }				
			},
		 cache: true,
		 cookie: {expires:30}
		});
})

function cookie_defined(cookie_name){
    if ($.cookie(cookie_name) != null){
      return true
    }else{return false}
  };
