<cfparam name="local.elementIds" default="#structNew()#">

<cfoutput>
    #view("includes/alerts")#

    <form method="post" style="max-width:600px" class="mb-5">        
        <div class="row">
            <label class="col-3 col-form-label">Account:</label>
            <div class="col-9">
                <select name="accountId" class="form-control form-control-sm">
                    <option value=""></option>
                    <cfloop array="#rc.accounts#" item="local.account">
                        <option value="#local.account.getId()#">
                            #local.account.getLongName()#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Keywords:</label>
            <div class="col-9">
                <input type="text" id="Keywords" name="Keywords" value="" class="form-control form-control-sm">
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Type:</label>
            <div class="col-9">
                <select name="CategoryId" class="form-control form-control-sm">
                    <option value=""></option>
                    <cfloop array="#rc.categories#" index="local.category">
                        <option value="#local.category.getId()#" >
                            #local.category.getName()#
                        </option>
                    </cfloop>
                </select>
            </div>
            
        </div>
        <!---
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
        
        <hr>

        <div class="row">
            <label class="col-3 col-form-label">Include Hidden?:</label>
            <div class="col-9 text-left">
                <input name="IncludeHidden" type="checkbox">
            </div>
        </div>
    --->
        <div class="row">
            <div class="col-9 offset-3">
                <button type="submit" class="btn btn-primary btn-sm"><i class="fa fa-search"></i> Search Transactions</button>
            </div>
        </div>
    </form>

    <script>
        viewScripts.add( function(){
            var $viewDiv = $('###local.templateid#'),
                $searchForm = $viewDiv.find("form"),
                $submitBtn = $searchForm.find("button[type='submit']"),
                $resultsTab = $("###local.elementIds.resultsTab#"),
                $resultsDiv = $("###local.elementIds.resultsDiv#");

            $searchForm.submit(function(event){
                event.preventDefault();
                $submitBtn.prop('disabled',true);
                $submitBtn.find("i").removeClass('fa-search').addClass('fa-spinner').addClass('fa-spin');
                console.log($submitBtn.length);
                $.get(
                    "#buildurl('transactionSearch.getSearchResults')#", 
                    $searchForm.serialize()
                )
                .done(function(response) {
                    $resultsDiv.html(response);
                    $resultsTab.tab('show');
                    $submitBtn.find("i").removeClass('fa-spinner').removeClass('fa-spin').addClass('fa-search');
                    $submitBtn.prop('disabled',false);
                })
                .fail(function(e) {
                    $("<div></div>").html(e.responseText).appendTo("body");
                });
                
                return false;
            });
        });
    </script>
</cfoutput>