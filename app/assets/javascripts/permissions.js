// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function initializeCheckboxesByEntity() {
  $('.selectpicker').selectpicker();
  $('#rooms2')
    .change(handleSelectAll)
    .trigger('change');
  handleEnabled($('#rooms2'), approveEventsChecked);
  $('[name="approve_events"]').change(function() {
    handleEnabled($('#rooms2'), approveEventsChecked);
  });
}

function updatePermissionsForEntity() {
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

function updateEntitiesForPermission() {
  $.ajax({
    url: '/permissions/entities_for_permission',
    type: 'POST',
    data: {
      permission: $('#permissions').val(),
      rooms: { approve_events: $('#rooms').val() }
    },
    dataType: 'html',
    success: function(data) {
      $('#entitiesDiv').html(data);
    }
  });
}

function permissionSubmitSuccess(event, data) {
  $('#flash_messages').bootstrap_flash(data.message, {type: data.type});
  updatePermissionsForEntity();
  updateEntitiesForPermission();
}

function handleSelectAll() {
  if (isElementOf($(this).val(), 'all')) {
    if(isElementOf($(this).data('prevVal'), 'all')) {
      $(this).children('option[value="all"]').prop('selected', false);
    }
    else {
      $(this).children('option').prop('selected', true);
    }
  }
  else {
    var allSelected = true;
    $(this).children('option[value!="all"]').each(function() {
      if (!$(this).prop('selected')) {
        allSelected = false;
        return false;
      }
    });
    $(this).children('option[value="all"]').prop('selected', allSelected);
    if (isElementOf($(this).data('prevVal'), 'all')) {
      $(this).children('option').prop('selected', false);
    }
  }
  $(this)
    .data('prevVal', $(this).val())
    .selectpicker('refresh');
}

function isElementOf(array, value) {
  return array && array.indexOf(value) !== -1;
}

function handleEnabled(target, condition) {
  target
    .prop('disabled', !condition())
    .selectpicker('refresh');
}

function approveEventsChecked() {
  return $('[name="approve_events"]').is(':checked');
}

function approveEventsSelected() {
  return $('#permissions').val() === 'approve_events';
}