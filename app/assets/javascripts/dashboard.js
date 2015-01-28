$(function()
{
	handleTaskAction();
});
$(document).on('page:load', handleTaskAction);

function handleTaskAction()
{
	$(".task-action").click(function()
	{
		var path = $(this).attr('data-path');
		var request = $.ajax({
			url: path,
			method: 'GET',
			dataType: 'json'
		});
		request.done(function()
			{
				location.reload();
			});
	});
}