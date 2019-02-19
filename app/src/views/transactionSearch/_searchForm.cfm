<cfoutput>

    #view("includes/alerts")#

    <cfset currentAccountId = 0>
    <cfif rc.keyExists('account')>
        <cfset currentAccountId = rc.account.getId()>
    </cfif>

    <form method="post" style="max-width:600px" class="mb-5">        
        <div class="row">
            <label class="col-3 col-form-label">Account:</label>
            <div class="col-9">
                <select name="accountId" class="form-control form-control-sm">
                    <cfloop array="#rc.accounts#" item="local.account">
                        <option value="#local.account.getId()#" #matchSelect(local.account.getId(), currentAccountId)#>
                            #local.account.getLongName()#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Keywords:</label>
            <div class="col-9">
                <input type="text" id="Description" name="Description" value="" class="form-control form-control-sm">
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Type:</label>
            <div class="col-9">
                <select name="Category" class="form-control form-control-sm">
                    <option value="" >
                        
                    </option>
                </select>
            </div>
            
        </div>
        <div class="row">
            <label class="col-3 col-form-label">Amount:</label>
            <div class="col-9">
                <div class="input-group input-group-sm">
                    <div class="input-group-prepend">
                        <input type="hidden" name="AmountType" value="">
                        <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown">Greater than</button>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="##">Equal to</a>
                            <a class="dropdown-item" href="##">Greater than</a>
                            <a class="dropdown-item" href="##">Less than</a>
                        </div>
                    </div>
                    <input name="Amount" type="text" class="form-control">
                </div>
            </div>
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Date:</label>
            <div class="col-9">
                <div class="input-group input-group-sm">
                    <input name="dateRange" type="text" class="form-control">
                    <div class="input-group-append">
                        <span class="input-group-text">
                            <i class="fa fa-calendar"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <hr>
        <div class="row">
            <label class="col-3 col-form-label">Limit:</label>
            <div class="col-9">
                <input name="limit" type="text" class="form-control">
            </div>
        </div>
        <div class="row">
            <label class="col-3 col-form-label">Sort By:</label>
            <div class="col-9">
                <input name="Sort" type="text" class="form-control">
            </div>
        </div>
        <div class="row">
            <label class="col-3 col-form-label">Include Hidden?:</label>
            <div class="col-9 text-left">
                <input name="IncludeHidden" type="checkbox">
            </div>
        </div>
        <div class="row">
            <div class="col-9 offset-3">
                <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Search Transactions</button>
            </div>
        </div>
    </form>
</cfoutput>
<script>
    viewScripts.add( function(){
        var $viewDiv = $('###local.templateid#'),
            $searchForm = $viewDiv.find("form"),
            $resultsDiv = $("###local.resultsDiv#");

        $searchForm.submit(){
            
            $.post({
                url: "#buildurl('transactionSearch.search')#",
                data: $searchForm.serialize()
            })
            .done(function(response) {
                $resultsDiv.html(response);
                $('#myTab a[href="#profile"]').tab('show') 
            });

            //select the results div

            //don't submit the form
            return false;
        }
    });
</script>