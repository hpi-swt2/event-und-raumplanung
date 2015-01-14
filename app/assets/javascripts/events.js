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
            i = 0;
            var msg = "";
            data.forEach(function (key) {
                if (msg === "") {
                    msg = '<li data-original-index="' + i + '"><a tabindex="' + i + '" class="" data-normalized-text="<span class=&quot;text&quot;>A-1.1</span>"><span class="text">' + data[key].name + '</span><span class="glyphicon glyphicon-ok check-mark"></span></a></li>';
                } else {
                    msg += '<li data-original-index="' + i + '"><a tabindex="' + i + '" class="" data-normalized-text="<span class=&quot;text&quot;>A-1.1</span>"><span class="text">' + data[key].name + '</span><span class="glyphicon glyphicon-ok check-mark"></span></a></li>';
                }
            });
            $(".selectpicker.dropdown-menu").html(msg);
        }
    });
}

$('.room_input').change(function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(getValidRooms, doneTypingInterval);
});

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
        typingTimer = setTimeout(checkVacancy, doneTypingInterval);
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);
