/*global $ */
// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.

var typingTimer,
    ready,
    doneTypingInterval = 1000;

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
            // $('#selectpicker').multiSelect('deselect_all');
            rooms.forEach(function (room) {
                room_ids.push(room.id);
            });
            console.log(room_ids);
            options = $('#selectpicker').children();
            options.each(function (index, option) {
                var value = parseInt($(option).attr('value'), 10);
                if ($.inArray(value, room_ids) !== -1) {
                    console.log(value);
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
};

$(document).ready(ready);
$(document).on('page:load', ready);
