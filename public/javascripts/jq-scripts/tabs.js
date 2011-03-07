$(document).ready(function(){
           
  $("#tabs").tabs({
			ajaxOptions: {
				  error: function( xhr, status, index, anchor ) {
					  $( anchor.hash ).html(
						  "Tenemos un error en el servidor. En verdad sentimos los problemas que esto le causa. Estamos trabajando para arreglarlos los antes posible");
				  }				  
			},
		 cache: false,
		 idPrefix:  'tickets-tabs-',
		 cookie: {expires:1}
		});
})
