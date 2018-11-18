$("body").addClass("show-template-wrappers");

$(".template-wrapper").each( function(){
    var $this = $(this),
        type = $this.data('template-type'),
        path = $this.data('template-path'),
        $label = $("<div></div>").addClass('template-label').html(type + ": " + path);
        $this.prepend($label);
});