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

$(document).ready(function(){
	Cookie.newCookie();		// Initialize Cookie for reports.
	
	$('input:checkbox[id]=ticket_to_report').live('click',			
				function(){
						if (this.checked){
							Cookie.push(this.value)
						}else{
							Cookie.pop(this.value)
						}
				})
});

var	Cookie = {
		cookieName	:	"tickets_to_report",
		
		push	:	function(value){
				cookieValues	=	Cookie.getValues()
				cookieValues.push(value)
				Cookie.setValues(cookieValues)
		},
		
		pop	:	function(value){
				cookieValues	=	Cookie.getValues()
				position	=	$.inArray(value, cookieValues)
				cookieValues.splice(position)
				Cookie.setValues(cookieValues)
		},
		
		getValues	:	function(){
				values	=	$.cookie(this.cookieName)
				if ($.cookie(this.cookieName) == "" )
					return values.split(',').splice()
				else
					return values.split(',')
		},
		
		setValues	:	function(newValues){				
				$.cookie(this.cookieName,
						newValues.join(',') )
		},
		
		newCookie	:	function(){
			$.cookie(this.cookieName, '')
		}
}
