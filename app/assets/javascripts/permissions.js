// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('#entity').change(updateUserPermissions);
  $('#permissions').change(updatePermittedEntities);
  $('#rooms').change(updatePermittedEntities);
  $(document).on('ajax:success', '#permissionsByPermission', permissionSubmitSuccess);
  $('#rooms').prop('disabled', !($('#permissions').val() == 'approve_events')).selectpicker('refresh');
  $('#permissions').change(function() {
    $('#rooms').prop('disabled', !($(this).val() == 'approve_events')).selectpicker('refresh');
  });
  $(document).on('ajax:success', '#permissionsByEntity', permissionSubmitSuccess);
  updatePermittedEntities();
  updateUserPermissions();
})

function updateUserPermissions() {
  $.ajax({
    url: '/permissions/permissions_for_entity',
    type: 'POST',
    data: { entity: $('#entity').val() },
    dataType: 'html',
    success: function(data) {
      $('#permissionsDiv').html(data);
    }
  });
}

function updatePermittedEntities() {
  $.ajax({
    url: '/permissions/permitted_entities',
    type: 'POST',
    data: {
      permission: $('#permissions').val(),
      rooms: { approve_events: $('#rooms').val()}
    },
    dataType: 'html',
    success: function(data) {
      $('#entitiesDiv').html(data);
    }
  });
}

function permissionSubmitSuccess(event, data) {
  $('#flash_messages').bootstrap_flash(data.message, {type: data.type});
  updateUserPermissions();
  updatePermittedEntities();
}