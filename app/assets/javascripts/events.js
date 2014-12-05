// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.


$(document).ready(function() { 
	$('#sugguest-form input').change(function() { 
		$.ajax({
			url: taskPath,
			type: 'PUT',
			data: {task: {done: target.checked}},
			dataType: 'json'
		})
}); 

}); 


