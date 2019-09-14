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
                    <div data-submit-errors></div>
                    <!--- when editing, add the delete button--->
                    <cfif rc.keyExists('eventGenerator')>
                        <div class="text-right" style="position:relative;height:0;">
                            <button type="button" class="btn btn btn-outline-danger btn-sm" style="position:relative" id="btnDeleteGenerator">
                                <i class="fa fa-trash"></i> Delete
                            </button>
                        </div>
                        <form id="deleteEventGenerator" method="post" style="display:none" action="#buildurl('schedular.deleteScheduledEvent')#">
                            <input type="hidden" name="type" value="#rc.eventGenerator.getGeneratorType()#">
                            <input type="hidden" name="eventGeneratorId" value="#rc.eventGeneratorId#">
                        </form>
                    </cfif>
                    <!--- Display the tabs --->
                    <ul class="nav nav-tabs" role="tablist">
                        <cfif rc.keyExists('transactionGenerator')>
                            <li class="nav-item">
                                <a class="nav-link #displayIf(rc.activeTab eq 'transaction', 'active')#" data-toggle="tab" href="##tabTransaction" role="tab" data-tab="transaction">
                                    New <span class="d-none d-sm-inline"> Automatic</span> Transaction
                                </a>
                            </li>
                        </cfif>
                        <cfif rc.keyExists('transferGenerator')>
                            <li class="nav-item">
                                <a class="nav-link #displayIf(rc.activeTab eq 'transfer', 'active')#" data-toggle="tab" href="##tabTransfer" role="tab" data-tab="transfer">
                                    New <span class="d-none d-sm-inline"> Automatic</span> Transfer
                                </a>
                            </li>
                        </cfif>
                    </ul>

                    <!--- Display the tab content panels --->
                    <div class="tab-content" id="myTabContent">
                        <cfif rc.keyExists('transactionGenerator')>
                            <div class="tab-pane fade #displayIf(rc.activeTab eq 'transaction', 'show active')#" id="tabTransaction" role="tabpanel">
                                #view("schedular/_transactionGeneratorForm")#
                            </div>
                        </cfif>
                        <cfif rc.keyExists('transferGenerator')>
                            <div class="tab-pane fade #displayIf(rc.activeTab eq 'transfer', 'show active')#" id="tabTransfer" role="tabpanel">
                                #view("schedular/_transferGeneratorForm")#
                            </div>
                        </cfif>
                    </div>

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
                $submitFormBtn = $modalDiv.find("[data-submit-form]");
                $tabLinks = $modalDiv.find("[data-tab]"),
                $tabPanes = $modalDiv.find(".tab-pane"),
                $errorDiv = $modalDiv.find("[data-submit-errors]"),
                $targetForm = {},

                setActiveForm = function($tab){     
                    var target = $tab.attr('href');
                    $targetForm = $tabPanes.filter(target).find("form");
                },

                disableButtons = function(){
                    $closeBtn.prop('disabled',true);
                    $saveBtn.prop('disabled',true);
                    addSpinner($saveBtn);
                },
                
                enableButtons = function(){
                    $closeBtn.prop('disabled',false);
                    $saveBtn.prop('disabled',false);
                    removeSpinner($saveBtn);
                };

            
            $saveBtn.click(function(){    
                disableButtons();        
                $.post({
                    type:'POST',
                    url: $targetForm.attr("data-validate-url"),
                    data: $targetForm.serialize()
                })
                .done(function(data) {
                    if (data.errors){
                        if (data.errors.length > 0){
                            $errorDiv.html(createAlert('danger','Please correct the following errors:',data.errors)).show();
                            enableButtons();
                        } else {
                            $targetForm.submit();
                        }
                    }
                    else {
                        $errorDiv.html(createAlert('danger','Please correct the following errors:',[data])).show();
                        enableButtons();
                    }
                    
                });
                
            });

            $("##btnDeleteGenerator").click(function(){
                disableButtons();
                $modalDiv.modal('hide');
                jConfirm("Are you sure you want to delete this auto payment?", function(){
                    $("##deleteEventGenerator").submit();
                    $modalDiv.modal('hide');
                }, function(){
                    $modalDiv.modal('show');
                    enableButtons();
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
