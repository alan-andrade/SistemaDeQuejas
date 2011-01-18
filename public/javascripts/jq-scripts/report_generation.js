$('input:checkbox[id]=ticket_to_report').live('click', function(){ 
      // Add memeber to the array.      
      if (this.checked == true){
        add_value_to_cookie('tickets_to_report', this)
      } else{
        remove_value_from_cookie('tickets_to_report', this)  
      }      
  });
  
    function add_value_to_cookie(cookie_name, object){
      if (cookie_defined(cookie_name) == true){     // Cookie Exists?
          values  = $.cookie(cookie_name).split(' ');  // values to_array
          values.push(object.value);                  // push value
          values  = $.unique(values);                 // remove repetition
          $.cookie(cookie_name, values.join(' '));
      } else{                                     // Initialize Cookie
        $.cookie(cookie_name, object.value);      
      }
    };
    
    function remove_value_from_cookie(cookie_name, object){
      value   = object.value
      values  = $.cookie(cookie_name).split(' ');
      values  = $.grep(values,  function(unmatched_value){return unmatched_value != value;});
      $.cookie(cookie_name, values.join(' '));
    };
    
    function cookie_defined(cookie_name){
      if ($.cookie(cookie_name) != null){
        return true
      }else{return false}
    }; 
