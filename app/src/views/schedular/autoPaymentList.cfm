<cfoutput>
    <div data-new-payment-modal>
        #view("schedular/_newAutoPaymentModal")#
    </div>
    <h3><i class="fa fa-exchange"></i> Auto Payments and Transfers</h3>
    <div class="text-right">
        <button type="button "class="btn btn-sm btn-primary" data-new>
            <i class="fa fa-plus"></i> Create new auto payment
        </button>
    </div>
    <cfif rc.generators.len() eq 0>
        <p class="text-info">
            You do not have any automatic payments or transfers scheduled.
        </p>
    </cfif>
    <cfloop array="#rc.generators#" item="local.eventGenerator">
        <div class="row">
            <div class="col-1">
                #local.eventGenerator.getEventName()#
            </div>
        </div>
    </cfloop>

    <script>
        viewScripts.add( function(){
            var viewId = '#local.templateid#',
                $viewDiv = $("##" + viewId),
                $newBtn = $viewDiv.find("[data-new]");
                $newAutoPayModal = $viewDiv.find("[data-new-payment-modal] .modal");

            $newBtn.click(function(){
                $newAutoPayModal.modal('show');
            });
        
        });
    </script>

</cfoutput>