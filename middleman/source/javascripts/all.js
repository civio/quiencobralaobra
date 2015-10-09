//= require_tree .
//= require bootstrap

var $cont,
    contWidth = 0;

$( document ).ready(function() {
    
  console.log( "ready!" );

  // Store cont & cont width
  $cont = $('body > .container');
  contWidth = $cont.width();

  // Add sort capability to tables
  $('.footable').footable();

  // Setup tooltips
  $('[data-toggle="tooltip"]').tooltip();

  // Setup Packery for Wall Layout
  var $wall = $('.wall');
  if ($wall.length){
    imagesLoaded( $wall, function() {
      $wall.packery({
        itemSelector: '.wall-item',
        columnWidth: $wall.width() / 12
      });
    });
  }

  // Resize Handler
  $(window).bind('resize', function(){

    if ($cont && contWidth !== $cont.width()) {

      contWidth = $cont.width();

      // Update packery column width
      if ($wall.length) {
        $wall.packery({
          itemSelector: '.wall-item',
          columnWidth: $wall.width() / 12
        });
      }
    }
  });
});