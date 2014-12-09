// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require knockout

$(function(){
	handleTaskCheckboxClick();
});

$(document).on('page:load', handleTaskCheckboxClick);

function handleTaskCheckboxClick()
{
	$(".task-done-checkbox").click(function(event)
	{
		var target = event.target;
		var taskPath = $(target).attr('data-taskpath');
        var taskUserId = $(target).attr('data-user_id');
		$.ajax({
			url: taskPath,
			type: 'PUT',
			data: {task: {done: target.checked, user_id: taskUserId}},
			dataType: 'json'
		});
	});
}

function upload()
{
    var file_data = $("#uploads_").prop("files")[0]; // Getting the properties of file from file field
    var form_data = new FormData(); // Creating object of FormData class
    form_data.append("uploads", file_data) // Appending parameter named file with properties of file_field to form_data
    form_data.append("id", 1) // Adding extra parameters to form_data
    $.ajax({
        url: "/tasks/upload_file",
        dataType: 'json',
        cache: false,
        contentType: false,
        processData: false,
        data: form_data,
        type: 'post',
        success: function(data) {
            alert(data[data.length-1].id);
            $("#list_uploads").append('<div>' +
                '<a class="list-group-item" style="width:85%; display: inline-block;" ' +
                'href="/files/' + data[data.length-1].id + '/' + data[data.length-1].file_file_name + '">' +
                data[data.length-1].file_file_name +
                '</a>' +
                ' ' +
                '<a class="btn btn-danger" rel="nofollow" ' +
                'href="/uploads/' + data[data.length-1].id + '" data-method="delete" data-confirm="Are you sure?">' +
                'Löschen' +
                '</a>' +
                '</div>');
        }
    });
}