/*global $*/
/*global jQuery*/
// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.

var typingTimer,
    ready,
    doneTypingInterval = 1000,
    EVENT_URL = '/events/',
    SUGGEST_URL = '/new_event_suggestion';

function isNum(val) {
    return (/^\d+$/).test(val);
}

function suggestionLink(id) {
    return "<br><a target='_blank' href=" + EVENT_URL + id + SUGGEST_URL + "> Alternative für Event " + id + " vorschlagen</a>";
}

function clearFlash() {
    $(".notice").html("");
}
function flashWarning(data) {
    var messages = [], output;
    jQuery.each(data, function (key, event) {
        if (key !== 'status') {
            messages.push(event.msg);
        }
    });
    output = "";
    jQuery.each(messages, function (key, msg) {
        output += '<div class="alert fade in alert-warning "><button class="close" data-dismiss="alert">×</button>' + msg + '</div>';
    });
    $(".notice").html(output);
}

function checkVacancy() {
    var rooms = [], data;
    $("#selectpicker option:selected").each(function () { rooms.push($(this).val()); });
    data = {
        event: {
            original_event_id: $('#event_original_event_id').val(),
            starts_at_date: $('#event_starts_at_date').val(),
            starts_at_time: $('#event_starts_at_time').val(),
            ends_at_date:  $('#event_ends_at_date').val(),
            ends_at_time: $('#event_ends_at_time').val(),
            room_ids: rooms
        }
    };
    $.ajax({
        url: '/checkVacancy',
        type: 'PATCH',
        data: data,
        dataType: 'json',
        beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function (data) {
            if (!data.status) {
                flashWarning(data);
            } else {
                clearFlash();
            }
        }
    });
}

function getValidRooms() {
    var equipment_ids = [], data, data_1, dict;
    $(".equipment:checked").each(function () { equipment_ids.push($(this).attr('id')); });
    data = {};
    data.room = {};
    data_1 = {
        size: $('#room_size').val(),
        property: $('#').val(),
        equipment: equipment_ids
    };
    dict = {};
    dict.equipment = {};
    equipment_ids.forEach(function (id) {
        dict.equipment[equipment_ids[id]] =  $('#' + equipment_ids[id]).val();
    });
    data.room = data_1;
    $.ajax({
        url: '/rooms/getValidRooms',
        type: 'POST',
        data: data,
        dataType: 'json',
        beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        success: function (rooms) {
            var room_ids = [],
                options;
            rooms.forEach(function (room) {
                room_ids.push(room.id);
            });
            options = $('#selectpicker').children();
            options.each(function (index, option) {
                var value = parseInt($(option).attr('value'), 10);
                if ($.inArray(value, room_ids) !== -1) {
                    $(option).attr('disabled', false);
                } else {
                    $(option).attr('disabled', true);
                }
            });
            $('#selectpicker').multiSelect('refresh');

        }
    });
}




ready = function () {
    $('#advancedSearch').on('shown.bs.collapse', function () {
        $(".drop-down-chevron").removeClass("glyphicon-chevron-right").addClass("glyphicon-chevron-down");
    });
    $('#advancedSearch').on('hidden.bs.collapse', function () {
        $(".drop-down-chevron").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-right");
    });
    $('#selectpicker').multiSelect();
    $('.room_input').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(getValidRooms, doneTypingInterval);
    });

    $('#event-form #selectpicker').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(checkVacancy, doneTypingInterval);
    });
    $('#event-form input').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(checkVacancy, doneTypingInterval);
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);
