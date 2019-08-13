<cfparam name="rc.viewModel" required="true">
<cfoutput>
    <h4 class="mb-4"><i class="fa fa-line-chart"></i> Account Balance</h4>

    <form method="post" style="max-width:600px" class="mb-5">     
        <div class="row">
            <label class="col-3 col-form-label">Trailing Average:</label>
            <div class="col-9">
                <cfset input = rc.viewModel.getTrailingAverage()>
                <select name="#input.getName()#" class="form-control form-control-sm">
                    <cfloop array="#input.getOptions()#" item="option">
                        <option value="#option.value#">
                            #option.text#
                        </option>
                    </cfloop>
                </select>   
            </div>
        </div>   
        <div class="row">
            <label class="col-3 col-form-label">Density:</label>
            <div class="col-9">
                <cfset input = rc.viewModel.getDensity()>
                <select name="#input.getName()#" class="form-control form-control-sm">
                    <cfloop array="#input.getOptions()#" item="option">
                        <option value="#option.value#">
                            #option.text#
                        </option>
                    </cfloop>
                </select>   
            </div>
        </div> 
        <div class="row">
            <label class="col-3 col-form-label">Accounts:</label>
            <div class="col-9">
                <cfset input = rc.viewModel.getAccounts()>
                <select name="#input.getName()#" class="form-control form-control-sm">
                    <cfloop array="#input.getOptions()#" item="option">
                        <option value="#option.value#">
                            #option.text#
                        </option>
                    </cfloop>
                </select>   
            </div>
        </div>
        <div class="row">
            <label class="col-3 col-form-label">Date Range:</label>
            <div class="col-4">
                <cfset input = rc.viewModel.getStartDate()>
                <input type="text" name="#input.getName()#" value="#input.getFormattedValue()#" class="form-control form-control-sm">
            </div>
            <div class="col-4">
                <cfset input = rc.viewModel.getEndDate()>
                <input type="text" name="#input.getName()#" value="#input.getFormattedValue()#" class="form-control form-control-sm">
            </div>
        </div>
        <div class="row">
            <div class="col-3"></div>
            <div class="col-4">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" value="" id="defaultCheck1">
                <label class="form-check-label" for="defaultCheck1">
                    Include Linked
                </label>
              </div>
            </div>
        </div>
    </form>
    #view("accountChart/accountChart")#
    
    <script>
        viewScripts.add( function(){

        });
    </script>

</cfoutput>