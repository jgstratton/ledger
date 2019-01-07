<cfoutput>
    <div id="modal#local.templateId#" class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">New Auto Payment or Transfer</h5>
                    <button type="button" class="close btn-sm" data-close aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger d-none" data-submit-errors></div>
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" data-toggle="tab" href="##tabPayment" role="tab" data-tab="transaction">New Automatic Transaction</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-toggle="tab" href="##tabTransfer" role="tab" data-tab="transfer">New Automatic Transfer</a>
                        </li>
                    </ul> 
                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane fade show active" id="tabPayment" role="tabpanel">
                            #view("schedular/_transactionGeneratorForm")#
                        </div>
                        <div class="tab-pane fade" id="tabTransfer" role="tabpanel">
                            #view("schedular/_transferGeneratorForm")#
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-sm" data-save>Save</button>
                    <button type="button" class="btn btn-secondary btn-sm" data-close>Close</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        viewScripts.add( function(){
            var $modalDiv = $("##" + "modal#local.templateId#"),
                $closeBtn = $modalDiv.find("[data-close]"),
                $saveBtn = $modalDiv.find("[data-save]"),
                $tabLinks = $modalDiv.find("[data-tab]"),
                $tabPanes = $modalDiv.find(".tab-pane"),
                $errorDiv = $modalDiv.find("[data-submit-errors]"),
                $targetForm = {},

                setActiveForm = function($tab){     
                    var target = $tab.attr('href');
                    $targetForm = $tabPanes.filter(target).find("form");
                };
            
            $saveBtn.click(function(){               
                $.post({
                    type:'POST',
                    url: $targetForm.attr("data-validate-url"),
                    data: $targetForm.serialize()
                })
                .done(function(data) {
                    console.log(data);
                    if (data.errors.length == 0){
                        $errorDiv.html(data).show();
                    } else {
                        //submit the form for real.
                    }
                })
                .fail(function() {
                    console.log(data).show();
                    $errorDiv.html(data);
                });
                
            });

            $closeBtn.click(function(){
                $modalDiv.modal('hide');
            });

            $tabLinks.click(function(){
                setActiveForm($(this));
            });

            setActiveForm($tabLinks.filter('.active'));
        });
    </script>
</cfoutput>
