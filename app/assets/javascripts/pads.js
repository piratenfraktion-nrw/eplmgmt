$(document).on('page:load', function() {
  initSnapper();
  setTimeout(initSnapper, 4000); 
});

function initSnapper() {
  $('.meny-arrow').on('click', function(){
    $('#pad-menu').modal();
  });
}
