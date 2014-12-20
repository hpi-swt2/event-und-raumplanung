/*global $ */
// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
var EVENT_URL = '/events/',
    SUGGEST_URL = '/new_event_suggestion',
    typingTimer,
    doneTypingInterval = 1000;

var ready;

function convertUTCDateToLocalDate(date) {
    var newDate, offset, hours;
    newDate = new Date(date.getTime() + date.getTimezoneOffset() * 60 * 1000);
    offset = date.getTimezoneOffset() / 60;
    hours = date.getHours();
    newDate.setHours(hours - offset);
    return newDate;
}
function isNum(val) {
    return (/^\d+$/).test(val);
}

function isSameDay(startDate, endDate) {
    if (startDate.getDate() === endDate.getDate() && startDate.getMonth() === endDate.getMonth()) {
        return true;
    }
    return false;
}

function getTime(date) {
    var hours, mins, hourOutput, minOutput;
    hours = date.getHours();
    mins = date.getMinutes();
    hourOutput = ((hours < 10) ? "0" + hours : hours);
    minOutput = ((mins < 10) ? "0" + mins : mins);
    return hourOutput + ":" + minOutput + " Uhr";
}

function suggestionLink(id) {
    return "<br/><a target='_blank' href=" + EVENT_URL + id + SUGGEST_URL + "> Alternative für Event " + id + " vorschlagen</a>";
}

function clearFlash() {
    $(".notice").html("");
}
function flashWarning(data) {
    var messages = [], room, room_msg, msg, starts_at, ends_at, starts_at_date, ends_at_date, starts_at_time, ends_at_time, time_msg, output, i, j;
    for (i in data) {
        if (isNum(i)) {
            if (data[i].rooms.length > 1) {
                room = "";
                for (j in data[i].rooms) {
                    if ( room === "") {
                        room = data[i].rooms[j];
                    } else {
                        room += ", " + data[i].rooms[j];
                    }
                }
                room_msg = "in den Räumen " + room;
            } else {
                room_msg = "im Raum " + data[i].rooms[0];
            }
            starts_at = convertUTCDateToLocalDate(new Date(data[i].starts_at));
            ends_at = convertUTCDateToLocalDate(new Date(data[i].ends_at));
            starts_at_date = starts_at.getDate() + "." + (starts_at.getMonth() + 1) + "." + starts_at.getFullYear();
            if (isSameDay(starts_at, ends_at)) {
                time_msg = "am " + starts_at_date;
            } else {
                ends_at_date = ends_at.getDate() + "." + (ends_at.getMonth() + 1) + "." + ends_at.getFullYear();
                time_msg = "vom " + starts_at_date + " bis zum " + ends_at_date;
            }
            starts_at_time =  getTime(starts_at);
            ends_at_time = getTime(ends_at);
            time_msg += " von " + starts_at_time + " bis " + ends_at_time;
            msg = "Ihre Alternative konfligiert mit dem Event " + i + " stattfindend " + " " + time_msg + " " + room_msg;
            msg += suggestionLink(i);
            messages.push(msg);
        }
    }
    output = "";
    for ( i in messages) {
        output += '<div class="alert fade in alert-warning "><button class="close" data-dismiss="alert">×</button>' + messages[i] + '</div>';
    }
    $(".notice").html(output);
}

function checkVacancy(e) {
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