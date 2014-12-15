// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.


var ready; 
ready = function() { 
	var typingTimer; 
	var doneTypingInterval = 1000; 
	$('#event-form input').change(function() { 
		clearTimeout(typingTimer); 
		typingTimer = setTimeout(checkVacancy, doneTypingInterval); 
	});

	$('#event-form #selectpicker').change(function() { 
		clearTimeout(typingTimer); 
		typingTimer = setTimeout(checkVacancy, doneTypingInterval); 
	});
// $(document).ajaxComplete(function(event, request) { 
// var flash = $.parseJSON(request.getResponseHeader('X-Flash-Messages'));
//   if(!flash) return;
//   if(flash.notice) { $('.notice').html('<div class="alert fade in alert-success"><button class="close" data-dismiss="alert">×</button>' + flash.notice + '</div>'); }
//   if(flash.warning) { $('.notice').html('<div class="alert fade in alert-warning"><button class="close" data-dismiss="alert">×</button>' + flash.warning + '</div>');}
//   if(flash.error) { /* code to display the 'error' flash */ alert("aa"); }
// }); 

	function checkVacancy(e) { 
		rooms = []
		$("#selectpicker option:selected").each(function(){ rooms.push($(this).val());}); 
		
		var data = { 	
			event: {
			starts_at_date: $('#event_starts_at_date').val(),
 			starts_at_time: $('#event_starts_at_time').val(),
 		 	ends_at_date:  $('#event_ends_at_date').val(),
 		 	ends_at_time: $('#event_ends_at_time').val(), 
 		 	room_ids: rooms
 			}
 		} 
		$.ajax({
			url: '/checkVacancy',
			type: 'PATCH',
			data: data,
			dataType: 'json',
			beforeSend: function(xhr) {
			 	xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));}, 
			 success:(function(data){
			 	if (!data["status"]) { 
			 		flashWarning(data); 
			 	}
			 	else 
			 		clearFlash(); 
			 //	var data = JSON.parse(data);
			// 	if(data['status']){ 
			// 		alert('true'); 
			// 	}
			// 	else 
			// 		alert('false');
		})
			// })
		}); 
	}; 
	
	function flashWarning(data) { 
	messages = [] 
	for(var i in data) {
		if(isNum(i)) {  
			if(data[i]["rooms"].length > 1) { 
				roomlist = "" // monosyndetic enumeration of all rooms as a string
				for(var j in rooms) { 
					if( roomlist == "") { 
						roomlist = data[i]["rooms"][j]; 
					}
					else {// suport.arra
						roomlist += ", " + data[i]["rooms"][j]; 
					}
				}
				room_msg = "in den Räumen " + room; 
				
			}
			else { 
				room_msg = "im Raum " + data[i].rooms[0] ; 
			} 
	 		var starts_at = convertUTCDateToLocalDate(new Date(data[i]["starts_at"]));
	 		var ends_at = convertUTCDateToLocalDate(new Date(data[i]["ends_at"]));
	 		var starts_at_date = starts_at.getDate() + "." + (starts_at.getMonth() + 1) + "." + starts_at.getFullYear();

	 		if(isSameDay(starts_at, ends_at)) {
	 			time_msg = "am " + starts_at_date 
	 		} 
	 		else { 
	 			var ends_at_date = ends_at.getDate() + "." + (ends_at.getMonth() + 1) + "." + ends_at.getFullYear();
	 			time_msg = "vom " + starts_at_date + " bis zum " + ends_at_date;  
	 		}
	 		var starts_at_time =  getTime(starts_at); 
	 		var ends_at_time = getTime(ends_at); 

	 		time_msg += " von " + starts_at_time + " bis " + ends_at_time; 
	 		msg = "Ihr Event konfligiert mit dem Event &rdquo;" + data[i]["event_name"] + "&rdquo; stattfindend " + " " + time_msg + " " + room_msg; 
			messages.push(msg)
		}
	} 
	output = ""
	for( var i in messages) { 
		output += '<div class="alert fade in alert-warning "><button class="close" data-dismiss="alert">×</button>' + messages[i] + '</div>';  
	} 
	 
	$(".notice").html(output); 
	}
	
	function convertUTCDateToLocalDate(date) {
    var newDate = new Date(date.getTime()+date.getTimezoneOffset()*60*1000);

    var offset = date.getTimezoneOffset() / 60;
    var hours = date.getHours();

    newDate.setHours(hours - offset);

    return newDate;   
	}
	function isNum(val) { 
		return /^\d+$/.test(val);
	} 
	
	function isSameDay(startDate, endDate) { 
	if(startDate.getDate() == endDate.getDate() && startDate.getMonth() == endDate.getMonth()) { 
		return true; 
	}
	else { 
		return false; 
	}
	}
	
	function getTime(date) { 
		var hours = date.getHours(); 
		var mins = date.getMinutes(); 
	
		var hourOutput = ((hours < 10) ? "0" + hours : hours);
		var minOutput = ((mins < 10) ? "0" + mins : mins);(hours < 10 ); 
		return hourOutput + ":" + minOutput + " Uhr" 
	}
	
	
	
	function clearFlash() { 
		$(".notice").html(""); 
	}
}; 
$(document).ready(ready);
$(document).on('page:load', ready);