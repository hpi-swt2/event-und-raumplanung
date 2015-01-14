// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('#user').change(updateUserPermissions);
  $('#permissions').change(updatePermittedEntities);
})

function updateUserPermissions() {
  $.ajax({
    url: '/permissions/user_permissions',
    type: 'POST',
    data: { user: $('#user').val() },
    dataType: 'html',
    success: function(data) {
      $('#permissionDiv').html(data);
    }
  });
}

function updatePermittedEntities() {
  $.ajax({
    url: '/permissions/permitted_entities',
    type: 'POST',
    data: { permission: $('#permissions').val() },
    dataType: 'html',
    success: function(data) {
      $('#entitiesDiv').html(data);
    }
  });
}