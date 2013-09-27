function initSnapper() {
  $('.meny-arrow').on('click', function(){
    $('#pad-menu').modal();
  });
}

$(document).ready(initSnapper);
$(document).on('page:load', initSnapper);
