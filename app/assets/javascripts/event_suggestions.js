/*global $ */
/*global jQuery*/
// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.

var EVENT_URL = '/events/',
    SUGGEST_URL = '/new_event_suggestion',
    typingTimer,
    doneTypingInterval = 1000;

var ready;

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
            starts_at_date: $('#event_suggestion_starts_at_date').val(),
            starts_at_time: $('#event_suggestion_starts_at_time').val(),
            ends_at_date:  $('#event_suggestion_ends_at_date').val(),
            ends_at_time: $('#event_suggestion_ends_at_time').val(),
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

ready = function () {
    $('#sugguest-form input').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(checkVacancy, doneTypingInterval);
    });
    $('#sugguest-form #selectpicker').change(function () {
        clearTimeout(typingTimer);
        typingTimer = setTimeout(checkVacancy, doneTypingInterval);
    });
};

$(document).ready(ready);
$(document).on('page:load', ready);