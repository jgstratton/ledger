<cfoutput>
    <div data-auto-payment-modal></div>

    #view("includes/alerts")#
    <div class="text-right">
        <h3 class="pull-left">Payment Schedular</h3>
        <button type="button "class="btn btn-sm btn-primary" data-new>
            <i class="fa fa-plus"></i> Add New
        </button>
    </div>


    <cfif rc.generators.len() eq 0>
        <p class="text-info text-left pt-3">
            You do not have any automatic payments or transfers scheduled.
        </p>
    <cfelse>
        <div class="sm-stretch">
            <table class="table table-striped">
                <tbody>
                    <cfloop array="#rc.generators#" item="local.eventGenerator">
                        <tr class="#displayIf(!local.eventGenerator.isScheduled(),'text-disabled')#">
                            <td>
                                <cfif local.eventGenerator.isScheduled()>
                                    <i class="fa fa-calendar-check-o text-primary"></i>
                                <cfelse>
                                    <i class="fa fa-calendar-o"></i>
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
                                <a class="btn btn-link btn-sm text-primary" data-edit data-id="#local.eventGenerator.getEventGeneratorId()#">
                                    <i class="fa fa-pencil"></i> edit
                                    
                                </a>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
    </cfif>

    <script>
        viewScripts.add( function(){
            var viewId = '#local.templateid#',
                $viewDiv = $("##" + viewId),
                $newBtn = $viewDiv.find("[data-new]");
                $editBtn = $viewDiv.find("[data-edit]"),
                $autoPayModalWrapper = $viewDiv.find("[data-auto-payment-modal]"),
                $editAutoPayModal = $viewDiv.find("[data-new-payment-modal]"),
            
            populateAndShowModal = function(html){
                $autoPayModalWrapper.html(html);
                var $modal = $autoPayModalWrapper.find(".modal");
                $modal.modal('show');
            };

            $newBtn.click(function(){
                $.get("#buildurl('schedular.autoPaymentNewModal')#", function(responseHtml) {
                    populateAndShowModal(responseHtml);
                });
            });

            $editBtn.click(function(){
                console.log($(this).data('id'));
                var data = {
                    eventGeneratorId: $(this).data('id')
                };
                $.get("#buildurl('schedular.autoPaymentEditModal')#", data, function(responseHtml) {
                    populateAndShowModal(responseHtml);
                });
            });
        
        });
    </script>

</cfoutput>