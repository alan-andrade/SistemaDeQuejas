$(document).ready(function(){
  $("#spinner").bind('ajaxSend', function(){
          $(this).show();
      }).bind('ajaxComplete',function(){
          $(this).hide();});
          
  $("#tabs").tabs({
			ajaxOptions: {
				  error: function( xhr, status, index, anchor ) {
					  $( anchor.hash ).html(
						  "Couldn't load this tab. We'll try to fix this as soon as possible. " +
						  "If this wouldn't be a demo." );
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
