// // Place all the behaviors and hooks related to the matching controller here.
// // All this logic will automatically be available in application.js.


var ready; 
ready = function() { 
	var typingTimer; 
	var doneTypingInterval = 1000; 

	$('.room_input').change(function() { 
		clearTimeout(typingTimer); 
		typingTimer = setTimeout(getValidRooms, doneTypingInterval); 	
	});

	function getValidRooms(){
		equipment_ids = []; 
		$(".equipment:checked").each(function(){ equipment_ids.push($(this).attr('id'))});
		var data = {}
		data['room'] = {} 

		data_1 = { 	
			size: $('#room_size').val(),
 			property: $('#').val(),
 			equipment: equipment_ids
 		}; 

 		var dict = {};
 		dict['equipment'] = {}; 
		for(i in equipment_ids ) { 
			dict['equipment'][equipment_ids[i]]	=  $('#' + equipment_ids[i]).val(); 	
		} 
		data['room'] = data_1; 

		$.ajax({
			url: '/rooms/getValidRooms',
			type: 'POST',
			data: data,
			dataType: 'json',
			beforeSend: function(xhr) {
			 	xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));}, 
			 success:(function(data){
			 	var i = 0; 
			 	msg = ""; 
			 	for(key in data) { 
			 		if(msg == "") { 
			 			msg = '<li data-original-index="' + i + '"><a tabindex="' + i + '" class="" data-normalized-text="<span class=&quot;text&quot;>A-1.1</span>"><span class="text">'+ data[key]['name'] + '</span><span class="glyphicon glyphicon-ok check-mark"></span></a></li>'; 
			 		}
			 		else { 
			 			msg += '<li data-original-index="' + i + '"><a tabindex="' + i + '" class="" data-normalized-text="<span class=&quot;text&quot;>A-1.1</span>"><span class="text">'+ data[key]['name'] + '</span><span class="glyphicon glyphicon-ok check-mark"></span></a></li>'; 
			 		}
			 	}  
			 	$(".selectpicker.dropdown-menu").html(msg)
			 })
		}); 
	 } 
}
$(document).ready(ready);
$(document).on('page:load', ready);