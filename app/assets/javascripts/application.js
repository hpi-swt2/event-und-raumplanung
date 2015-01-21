// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery-ui/effect-highlight
//= require jquery-ui/widget
//= require jquery-ui/mouse
//= require jquery.ui.touch-punch
//= require twitter/bootstrap
//= require turbolinks
//= require bootstrap-select
//= require fullcalendar
//= require moment
//= require filterrific/filterrific-jquery
//= require moment
//= require bootstrap-datetimepicker
//= require moment/de
//= require recurring_select
//= require_tree .
//= require jquery-ui/autocomplete

jQuery.fn.bootstrap_flash = function(message, options) {
  options = options || {};
  options.timeout = options.timeout || 5000;
  options.type = options.type || 'notice';
  options.type = options.type == 'notice'? 'success' : options.type;
  options.type = options.type == 'alert'? 'warning' : options.type;
  options.type = options.type == 'error'? 'danger' : options.type;
  flashbox = $('<div />').addClass('alert fade in alert-' + options.type);
  flashbox.append($('<button />').addClass('close').attr('data-dismiss', 'alert').text('×'));
  flashbox.append(message);
  this.append(flashbox);
  setTimeout(function(){
    $('button', flashbox).click();
  }, options.timeout);
}
