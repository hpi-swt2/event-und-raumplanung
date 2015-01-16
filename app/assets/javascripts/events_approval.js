/*global $ */
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var EVENT_URL = '/events/',
    SUGGEST_URL = '/new_event_suggestion',
    DECLINE_URL = '/decline',
    ready;

function declineEvent(id) {
    $.ajax({
        url: EVENT_URL + id + DECLINE_URL,
        type: 'GET',
        dataType: 'json',
        beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')); },
        success: function (data) {
            return;
        }
    });
}

function insertSuggestLink(id) {
    $(".suggest-btn").attr("href", EVENT_URL + id + SUGGEST_URL);
}

function getRoomNames(rooms) {
    var room_names = "";
    rooms.forEach(function (room) {
        if (room_names === "") {
            room_names += room.name;
        } else {
            room_names += ", " + room.name;
        }
    });
    return room_names; //rooms.toString();
}

function convertUTCDateToLocalDate(date) {
    var newDate = new Date(date.getTime() + date.getTimezoneOffset() * 60 * 1000),
        offset = date.getTimezoneOffset() / 60,
        hours = date.getHours();

    newDate.setHours(hours - offset);

    return newDate;
}

function insertEventIntoModal(data) {
    var starts_at = convertUTCDateToLocalDate(new Date(data.starts_at)),
        ends_at = convertUTCDateToLocalDate(new Date(data.ends_at));
    $("#myModalLabel").html("Event " + data.id);
    $("#event_id").html(data.id);
    $("#event_name").html(data.name);
    $("#event_description").html(data.description);
    $("#event_rooms").html(getRoomNames(data.rooms));
    $("#event_participant_count").html(data.participant_count);
    $("#event_starts_at").html(starts_at.toLocaleString());
    $("#event_ends_at").html(ends_at.toLocaleString());
    $("#event_user").html(data.user);
}

function clickHandler(e) {
    e.preventDefault();
    var id = this.id, event_id = id.split("#")[1];
    $.ajax({
        url: EVENT_URL + event_id + ".json",
        type: 'GET',
        dataType: 'json',
        beforeSend: function (xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')); },
        success: function (data) {
            insertSuggestLink(data.id);
            insertEventIntoModal(data);
            $('#myModal').modal('toggle');
            declineEvent(data.id);
        }
    });
}



ready = function () {
    $(".decline-btn").unbind("click").click(clickHandler);
};


$(document).ready(ready);
$(document).on('page:load', ready);