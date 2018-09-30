jConfirm = function(confirmMessage, fncOk, fncCancel){

    var fncCancel = fncCancel || function(){};

    var modalString = `
        <div id="modalConfirmDiv" tabindex="-1" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>` + confirmMessage + `</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success">Ok</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                </div>
                </div>
            </div>
        </div>`;

    $(modalString).appendTo('body');
    
    $("#modalConfirmDiv .btn-success").click(fncOk);

    $("#modalConfirmDiv .btn-danger").click(function(){
        fncCancel();
        $("#modalConfirmDiv").modal('hide');
    });
    
    $("#modalConfirmDiv").modal({
        show:true
    });
    
    $("#modalConfirmDiv").on('hidden.bs.modal', function () {
        $(this).data('bs.modal', null).remove();
    });

}

//post form data using javascript
post = function(path, formData){

    var $form = $("<form />", { method: 'POST', action: path });

    for(var field in formData){
        var $field = $("<input />", {type: "hidden", name: field, value: formData[field] });
        $form.append($field);
    }

    $("body").append($form);
    $form.submit();
}

$("[data-datepicker]").datepicker().click(function(){
    var $this = $(this);
    if(Math.max(document.documentElement.clientWidth, window.innerWidth || 0) < 768){
        $this.prop('readonly',true);
    } else {
        $this.prop('readonly',false);
    }
    
}).attr("autocomplete", "off");  

//create a jquery function similar to $.getJSON but have it use POST instead of GET
postJSON = function(url, data, callback){
   
    $.ajax({
        url: url,
        type: "POST",
        dataType: "json",
        data:data
    })
    .done(function(data){
        callback(data);
    })
    .fail(function(a, b){
        $("body").append(a.responseText);
    });
}

//Remove on-load highlights
$(".temp-highlight-row.table-success").removeClass("table-success");

/* 
    Get elements by the data-js-hook attribute  (which can be a list of hooks)
     1. Get all elements that contain the jsHook variable
     2. Only return results that match a list item
*/
var jsHook = {

    getElement: function(hookName){
        var $matchedElements = $("[data-js-hook*=" + hookName + "]");
        
        return $matchedElements.filter(function(){
            var hooks = $(this).data('jsHook').split(",");
            for( var i = 0; i < hooks.length; i++ ){
                if(hooks[i] == hookName){
                    return true;
                }
            }
            return false;
        });
    }
}
