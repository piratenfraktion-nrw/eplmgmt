$(function() {
  window.snapper = new Snap({
    element: $('.pads.show iframe')[0]
  });
  window.snapper.on('open', function() {
    $('.snap-drawer-left').fadeIn();
  });
  window.snapper.on('close', function() {
    $('.snap-drawer-left').fadeOut();
  });
  
  $('#toggle-menu').on('click', function(){
    toggleMenu();
  });
});

function toggleMenu() {
  if( window.snapper.state().state === 'left' ){
    window.snapper.close();
  } else {
    window.snapper.open('left');
  }
}
document.domain = document.domain;
