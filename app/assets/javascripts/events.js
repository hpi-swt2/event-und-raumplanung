// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.


$(document).ready(function() { 
	$('#sugguest-form input').change(checkVacancy);
	$('#sugguest-form #selectpicker').change(checkVacancy);

$(document).ajaxComplete(function(event, request) { 
var flash = $.parseJSON(request.getResponseHeader('X-Flash-Messages'));
  if(!flash) return;
  if(flash.notice) { /* code to display the 'notice' flash */ $('.flash.notice').html(flash.notice); }
  if(flash.warning) { 			alert(flash.warning)}
  if(flash.error) { /* code to display the 'error' flash */ alert(flash.error); }
}); 
}); 

function checkVacancy(e) { 
		e.preventDefault();
		rooms = []
		$("#selectpicker option:selected").each(function(){ rooms.push($(this).val());}); 
		
		var data = { 	
			event: {
			event_id: $('#event_id').val(),
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
			dataType: 'html',
			beforeSend: function(xhr) {
			 	xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));}, 
			 success:(function(data){
			 	var btn = $("#submit_suggestion")
			 	btn.before("<div class='alert fade in alert-success'>Erfolgreich abgemeldet.</div>");
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


