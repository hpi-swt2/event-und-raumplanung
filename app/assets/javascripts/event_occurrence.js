// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


jQuery(document).ready(function($) {
	$("#trigger-delete-dialog").click(function() {
		$("body").append($("#delete-event").detach());
		$("body").append($("#delete-event-overlay").detach());
		$("#delete-event").css("display", "inline-block");
		$("#delete-event-overlay").css("display", "inline-block");
		$("#delete-event-overlay").css("width", $("body").css("width"));
		$("#delete-event-overlay").css("height", $("body").css("height"));
	});

	$("#delete-event-overlay").click(function() {
		$(this).css("display", "none");
		$("#delete-event").css("display", "none");
	})
});