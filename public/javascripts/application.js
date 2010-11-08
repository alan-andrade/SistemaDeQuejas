$(document).ready(function(){
  // Flash Message Animation
  if ($('.flash').length > 0){
    $('.flash').slideDown(1000).delay(2500).slideUp(1000)
  };
  
  // Little Icons rendering
    // PDF links
    var links  = $('a[href$=.pdf]');
    links.each(function(i){
      $(this).css({ 'padding-left'        : '20px',
                    'padding-bottom'      : '5px',
                    'background-image'    : 'url("../images/icons/page_white_acrobat.png")',
                    'background-position' : 'top-left',
                    'background-repeat'   : 'no-repeat' });
    });
  
  // Adding tickets to an array stored in a cookie for mass report generation.
  $('input:checkbox[id]=ticket_to_report').change(function(){ 
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
  
  // Check the boxes that their values are in the cookies.
  $.each( $('input:checkbox[id]=ticket_to_report'), function(index, cb){
    if(cookie_defined('tickets_to_report')==true){
      values  = $.cookie('tickets_to_report').split(' ');
      if ($.inArray(cb.value, values) != -1 ){
        cb.checked = true;
      };
    };
  });  

});
