//= require_tree .

$( document ).ready(function() {
    
  console.log( "ready!" );

  // Add sort capability to tables
  $('.footable').footable();

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
});