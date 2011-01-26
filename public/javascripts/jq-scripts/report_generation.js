var reportHelper  = { // Variable that hooks functions usefull on the tickets table
    selectAll : function(section){ 
        this.checkTags(this.buildSection(section),true)
    },
    deselectAll : function(section){
        this.checkTags(this.buildSection(section),false)
    },
 
    buildSection : function(section){
      section = ':input.' + section.className    
      return section
    },
    
    checkTags : function(section, value){
        $(section).each(function(){
            this.checked  = value
            value == true ? add_value_to_cookie(this) : remove_value_from_cookie(this)
        });
    }
};


$(document).ready(function(){                            // Functionality of the Select All and Deselect All.
    $('#checkall-button').live('click', function(event){ // We cant use .live with toggle.
        if(this.innerHTML == "Todos"){                   // That is why we need to check the innerHTML
          reportHelper.selectAll(this)
          this.innerHTML  = 'Ninguno'
        }else{
          reportHelper.deselectAll(this)
          this.innerHTML  = 'Todos'
        }
        event.preventDefault();
    })
});


$('input:checkbox[id]=ticket_to_report').live('click', function(){  // Use cookies when click the checkbox to make a report.
      // Add memeber to the array.      
      if (this.checked == true){
        add_value_to_cookie(this)
      } else{
        remove_value_from_cookie(this)  
      }      
  });
  
  function add_value_to_cookie(object){
    cookie_name = 'tickets_to_report'
    if (cookie_defined(cookie_name) == true){     // Cookie Exists?
        values  = $.cookie(cookie_name).split(' ');  // values to_array
        values.push(object.value);                  // push value
        values  = $.unique(values);                 // remove repetition
        $.cookie(cookie_name, values.join(' '));
    } else{                                     // Initialize Cookie
      $.cookie(cookie_name, object.value);      
    }
  };

  function remove_value_from_cookie(object){
    cookie_name = 'tickets_to_report'
    value   = object.value
    values  = $.cookie(cookie_name).split(' ');
    values  = $.grep(values,  function(unmatched_value){return unmatched_value != value;});
    $.cookie(cookie_name, values.join(' '));
  }; 
