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