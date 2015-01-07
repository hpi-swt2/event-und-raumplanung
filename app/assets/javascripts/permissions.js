// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('#user')
    .change(updateUserPermissions)
    .load(updateUserPermissions());
})

function updateUserPermissions() {
  $.ajax({
    url: '/permissions/user_permissions',
    type: 'POST',
    data: { user_id: $('#user').val() },
    dataType: 'html',
    success: function(data) {
      $('#categoryDiv').html(data);
    }
  });
}