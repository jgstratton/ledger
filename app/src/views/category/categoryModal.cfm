<cfparam name="rc.url.delete" default="">

<cfoutput>
    <div id="modal#local.templateId#" class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">New Category</h5>
                    <button type="button" class="close btn-sm" data-close aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div data-submit-errors></div>

                    <form method="post" action="#rc.url.submit#" data-validate-url="#rc.url.validate#" data-delete-url="#rc.url.delete#">
                        <input type="hidden" name="categoryId" value="#rc.categoryId#">
                        <div class="row">
                            <label class="col-3 col-form-label">Name:</label>
                            <div class="col-6">
                                <input type="text" name="name" value="#rc.category.getName()#" class="form-control form-control-sm">
                            </div>
                            <cfif rc.categoryId>
                                
                                <div class="col-3 text-right">
                                    <button type="button" class="btn btn btn-outline-danger btn-sm" style="position:relative" data-delete>
                                        <i class="fa fa-trash"></i> Delete
                                    </button>
                                </div>
                            </cfif>
                        </div>
                        <div class="row">
                            <label class="col-3 col-form-label">Type:</label>
                            <div class="col-9">

                                <label>
                                    <input type="radio" name="multiplier" value="-1" autocomplete="off" #checkif(rc.multiplier eq -1)#> 
                                    Decreases Funds <i class="fa fa-minus text-danger"></i>
                                </label>
                                <br>
                                <label>
                                    <input type="radio" name="multiplier" value="1" autocomplete="off" #checkif(rc.multiplier eq 1)#> 
                                    Increases Funds <i class="fa fa-plus text-success"></i>
                                </label>
                              
                            </div>
                        </div>
                    </form>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-sm" data-save>
                        <i class="fa fa-floppy-o"></i> Save
                    </button>
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-close>
                        <i class="fa fa-times"></i> Close
                    </button>
                </div>

            </div>
        </div>
    </div>
    <script>
        viewScripts.add( function(){
            var $modalDiv = $("##" + "modal#local.templateId#"),
                $closeBtn = $modalDiv.find("[data-close]"),
                $saveBtn = $modalDiv.find("[data-save]"),
                $deleteBtn = $modalDiv.find("[data-delete]"),
                $errorDiv = $modalDiv.find("[data-submit-errors]"),
                $form = $modalDiv.find("form"),

                disableButtons = function(){
                    $saveBtn.prop('disabled', true);
                },

                enableButtons = function(){
                    $saveBtn.prop('disabled', false);
                };

            $saveBtn.click(function(){    
                disableButtons();        
                $.post({
                    type:'POST',
                    url: $form.attr("data-validate-url"),
                    data: $form.serialize()
                })
                .done(function(data) {
                    if (data.errors){
                        if (data.errors.length > 0){
                            $errorDiv.html(createAlert('danger','Please correct the following errors:',data.errors)).show();
                            enableButtons();
                        } else {
                            $form.submit();
                        }
                    }
                    else {
                        $errorDiv.html(createAlert('danger','Please correct the following errors:',[data])).show();
                        enableButtons();
                    }
                    
                });  
            });

            $deleteBtn.click(function(){
                $form.prop('action', $form.attr("data-delete-url")).submit();
            });

            $closeBtn.click(function(){
                $modalDiv.modal('hide');
            });

        });
    </script>
</cfoutput>




