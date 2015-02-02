/*global $ */
// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.

var typingTimer,
    ready,
    doneTypingInterval = 1000;

function getValidRooms() {
    var equipment_ids = [], data, data_1, dict, i;
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
        success: function (data) {
            // hide and uncolor all rooms
            var allRooms = $('.selectpicker option');
            allRooms.each(function(key){
                var value = allRooms[key].getAttribute('value');
                var room = $('.selectpicker').find('[value=' + value + ']');
                room.hide();
                room.css('backgroundColor','');
            });

            // show and color selected rooms
            var selectedRooms = $('.selectpicker option:selected');
            selectedRooms.each(function(key){
                var value = selectedRooms[key].getAttribute('value');
                var room = $('.selectpicker').find('[value=' + value + ']');
                room.show();
                room.css('backgroundColor','red');
            });

            // show and uncolor valid rooms
            $.each(data, function(value) {
                var room = $('.selectpicker').find('[value=' + value + ']');
                room.show();
                room.css('backgroundColor','');
            });

            // show changes
            $('.selectpicker').selectpicker('refresh');
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
    $('.selectpicker').selectpicker();
    $('#event-form #selectpicker').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(function(){checkVacancy(); getValidRooms();}, doneTypingInterval);
    });
    $('.room_input').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(getValidRooms, doneTypingInterval);
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);
