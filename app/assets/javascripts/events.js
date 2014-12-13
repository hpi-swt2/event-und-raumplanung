// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.

$(function() {
  $('#advancedSearch').on('shown.bs.collapse', function () {
    $(".drop-down-chevron").removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-down");
  });
  
  $('#advancedSearch').on('hidden.bs.collapse', function () {
    $(".drop-down-chevron").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-right");
  });
  $('.datetimepicker').datetimepicker({
    language: 'de'
  });
  $('.selectpicker').selectpicker();
});