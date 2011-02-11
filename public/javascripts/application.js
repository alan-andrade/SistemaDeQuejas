$(document).ready(function(){
  // Flash Message Animation
  if ($('.flash').length > 0){
    $('.flash').slideDown(1000).delay(2500).slideUp(1000)
    $('.flash').click(function(){
        $(this).hide()
      })
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
});
