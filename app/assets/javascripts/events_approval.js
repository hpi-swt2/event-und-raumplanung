// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
EVENT_URL = '/events/'
SUGGEST_URL = '/new_event_suggestion'
$(document).ready(function() { 
	$(".decline-btn").click(function(e) { 
		e.preventDefault(); 
		var id = this.id;
		var event_id = id.split("#")[1]
		$.ajax({
				url: EVENT_URL + event_id + ".json",
				type: 'GET',
				dataType: 'json',
				beforeSend: function(xhr) {
				 	xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));}, 
				 success:(function(data){
					// alert("success");
					insertSuggestLink(data["id"]);  
					insertEventIntoModal(data); 
					$('#myModal').modal('toggle');
		})}); 
});
});

function insertEventIntoModal(data) { 
	var starts_at = convertUTCDateToLocalDate(new Date(data["starts_at"]));
	var ends_at = convertUTCDateToLocalDate(new Date(data["ends_at"]));
	$("#myModalLabel").html("Event " + data["id"]);
	$("#event_id").html(data["id"]);
	$("#event_name").html(data["name"]);
	$("#event_description").html(data["description"]);
	$("#event_rooms").html(getRoomNames(data["rooms"]));
	$("#event_participant_count").html(data["participant_count"]);
	$("#event_starts_at").html(starts_at.toLocaleString());
	$("#event_ends_at").html(ends_at.toLocaleString());
	$("#event_user").html(data["user"]);

}

function insertSuggestLink(id) { 
	$(".suggest-btn").attr("href", EVENT_URL + id + SUGGEST_URL); 
}

function getRoomNames(rooms) { 
	room_names = ""
	for ( var i in rooms) { 
		if( room_names == "") { 
			room_names += rooms[i]["name"] 
		}
		else { 
			room_names += ", " + rooms[i]["name"] 
		}
	} 
	return room_names //rooms.toString(); 	
}

function convertUTCDateToLocalDate(date) {
    var newDate = new Date(date.getTime()+date.getTimezoneOffset()*60*1000);

    var offset = date.getTimezoneOffset() / 60;
    var hours = date.getHours();

    newDate.setHours(hours - offset);

    return newDate;   
}
