// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.
 $(document).ready(function(){

 window.onload = function() {
};

}); 

$(document).on('page:load', $('.selectpicker').selectpicker());

// function processForm(e) {
//     e.preventDefault();
    
   
//     /* do what you want with the form */

//   	data = { event: { 
//   		name: $('#edit_event_3  #event_name').val(),
// 		description:  $('#edit_event_3  #event_description').val(),
// 		participant_count: $('#edit_event_3  #event_participant_count').val(),
// 		start_date: $('#edit_event_3  #event_start_date').val(),
// 		start_time: $('#edit_event_3  #event_start_time').val(),
// 		end_date:  $('#edit_event_3  #event_end_date').val(),
// 		end_time: $('#edit_event_3  #event_end_time').val(),
// 		is_private : $('#edit_event_3 #event_is_private').val(),
// 		rooms_attributes: [ 
// 			{ name: 'A1.1' },
//     		{ name: 'A1.1' }
//     	], 
// 		},  
// 		commit:  "Event aktualisieren"
//   	}

// 	$.ajax({
// 	  type: "PATCH",
// 	  url: 'http://localhost:3000/events/3',
// 	  data: data,
// 	  success:(function(){ 
// 	  	location.reload();}) ,
// 	  dataType: 'json'
// 	});

// 	return true;
// }



// $('#edit_event_3 .btn-primary').click(processForm);
// });