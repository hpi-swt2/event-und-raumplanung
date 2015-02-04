// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

/*$(function() {
    $('tr[data-link]').click(function() {
        window.location = $(this).data('link');
    });
});*/



ready = function () {
   
    $('#my-select').multiSelect();
}

$(document).ready(ready);
$(document).on('page:load', ready);