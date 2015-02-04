// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require knockout

$(function(){
	handleTaskCheckboxClick();

    autocompleteCache = {};
    userAutocomplete();
});

$(document).on('page:load', handleTaskCheckboxClick);

function handleTaskCheckboxClick()
{
	$(".task-done-checkbox").click(function(event)
	{
		var target = event.target;
		var taskPath = $(target).attr('data-taskpath');
		$.ajax({
			url: taskPath,
			type: 'PUT',
			data: {task: {done: target.checked }},
			dataType: 'text'
		}).then(function() {
            if ( $(target).hasClass("task-done-checkbox-from-dashboard") ){
                window.location.reload(); 
            } 
        });
            
	});
}

function addUploadField()
{
    var template = $("#task_upload_template");
    var newUpload = template.clone();
    var uploadsCount = $("input[name='uploads[]']").size() + 1;

    newUpload.attr("id", "task_upload_" + uploadsCount);
    newUpload.children("input").attr("id", "uploads_" + uploadsCount);
    newUpload.children("button").attr("id", "delete_upload_" + uploadsCount);
    newUpload.children("button").attr("name", "delete_upload_" + uploadsCount);
    newUpload.children(".task-upload-name").text("");

    newUpload.children("input").show();
    newUpload.children(".task-upload-name, button").hide();
    template.parent().append(newUpload);
}

function onUploadFileSelected(target)
{
    var upload = $(target).parent();
    var fileName = $(target).prop("files")[0].name;
    upload.children(".task-upload-name").text(fileName);

    upload.children("input").hide();
    upload.children(".task-upload-name, button").show();
}

function removeUploadFile(target)
{
   var upload = $(target).parent();
   upload.remove(); 
}

function removeTaskFile(target)
{
    var upload = $(target).parent();
    upload.children("input[type='hidden']").val("true");
    upload.hide();
}

function userAutocomplete()
{
    var autocomple_url = $("#task_identity_display").data("autocomplete-url");
    $("#task_identity_display").autocomplete(
    {
        minLength: 2,
        change: function(event, ui)
        {
            if (ui.item == null || ui.item == undefined)
            {
                $("#task_identity").val("");
                if ($("#task_identity_display").val() != "")
                {
                    $("#task_identity_display").val("");
                    $("#task_identity_display").parent().addClass("has-error");
                    setTimeout(function(){
                        $('#task_identity_display').parent().removeClass("has-error");
                    },1000);
                }
                else
                {
                    $("#task_identity_display").parent().removeClass("has-error");
                }
            }
        },
        select: function( event, ui ) 
        {
            $("#task_identity").val(ui.item.id);
        },
        source: function(request, response) 
        {
            var term = request.term;
            if (term in autocompleteCache) 
            {
                response(autocompleteCache[term]);
                return;
            }
 
            $.getJSON(autocomple_url, {search: term}, function(data, status, xhr) 
            {
                autocompleteCache[term] = data;
                response(data);
            });
        }
    });
}