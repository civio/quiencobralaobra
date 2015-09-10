//= require_tree .
//= require bootstrap

$( document ).ready(function() {
    
  console.log( "ready!" );

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
});