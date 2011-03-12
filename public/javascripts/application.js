$(document).ready(function(){
  // Flash Message Animation
  if ($('.flash').length > 0){    
    $('.flash').delay(2500).slideUp(1000)
      .click(function(){
        $(this).hide()
      })
  };
         
  $('.flash #notice').addClass('ui-state-highlight');
  $('.flash #error').addClass('ui-state-error');
  $('#nav-bar > a').each(function(i){$(this).addClass('jq-button')})  
  $('.jq-button').each(function(i){ $(this).button() })
  $('#delete-button').button({icons: {primary: 'ui-icon-trash'}});
  $('#edit-button').button({icons: {primary: 'ui-icon-pencil'}});
  $('#back-button').button({icons: {primary: 'ui-icon-arrowreturnthick-1-w'}})
  $('#close-ticket-button').button({icons: {primary: 'ui-icon-check'}})
  
  $('.field').append("<div style='clear:both'></div>"); //some stylin for forms  
  
  $('.change #content-toggle').click(
      function(){
          $(this).siblings('.content').slideToggle();
          $(this).children('.ui-icon').toggleClass('ui-icon-minusthick')
      });
      
  // Little Icons rendering
    // PDF links
    var links  = $('a[href$=.pdf]');
    links.each(function(i){
        if (!$(this).hasClass('jq-button')){
            $(this).css({ 'padding-left'        : '20px',
                          'padding-bottom'      : '5px',
                          'background-image'    : 'url("/images/icons/page_white_acrobat.png")',
                          'background-position' : 'top-left',
                          'background-repeat'   : 'no-repeat' });}
        else{
            $(this).button({ icons:{primary: 'ui-icon-document'} })
        }
    });

});
