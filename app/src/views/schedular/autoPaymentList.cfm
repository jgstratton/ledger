<cfoutput>
    <div data-new-payment-modal>
        #view("schedular/_newAutoPaymentModal")#
    </div>

    <div class="sm-pad">
        #view("includes/alerts")#
        <div class="text-right">
            <h3 class="pull-left">Payment Schedular</h3>
            <button type="button "class="btn btn-sm btn-primary" data-new>
                <i class="fa fa-plus"></i> Add New
            </button>
        </div>
    </div>

    <cfif rc.generators.len() eq 0>
        <p class="text-info text-left pt-3 sm-pad">
            You do not have any automatic payments or transfers scheduled.
        </p>
    <cfelse>
        <table class="table table-striped">
            <tbody>
                <cfloop array="#rc.generators#" item="local.eventGenerator">
                    <tr>
                        <td>
                            <cfif local.eventGenerator.isScheduled()>
                                <i class="fa fa-calendar-check-o text-primary"></i>
                            <cfelse>
                                <i class="fa fa-calendar-times-o text-muted"></i>
                            </cfif>
                        </td>
                        <td>
                            <i class="fa fa-fw #local.eventGenerator.getGeneratoricon()#"></i>
                            #local.eventGenerator.getEventName()#
                        </td>
                        <td>
                            <span class="d-none d-md-inline">#local.eventGenerator.getGeneratorType()#</span>
                        </td>
                        <td class="d-none d-md-table-cell">
                            #local.eventGenerator.getSourceAccount().getName()#
                        </td>
                        
                        <td class="text-right">#dollarformat(local.eventGenerator.getAmount())#</td>
                        <td class="text-right">
                            <a class="btn btn-link btn-sm">
                                <i class="fa fa-pencil"></i> edit
                            </a>
                        </td>
                    </tr>
                </cfloop>
            </tbody>
        </table>
 
    </cfif>
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