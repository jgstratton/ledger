<cfoutput>

    <h4 class="mb-4"><i class="fa fa-search"></i> Search Checkbook Transactions</h4>

    <ul class="nav nav-tabs">
        <li class="nav-item">
            <a class="nav-link #matchDisplay(getItem(),'search','active disabled')#" href="##searchForm">Search</a>
        </li>
        <li class="nav-item">
            <a class="nav-link #matchDisplay(getItem(),'searchResults','active disabled')#" href="##searchResults" id="">Results</a>
        </li>
        <li class="nav-item">
            <span class="nav-link  #matchDisplay(getItem(),'edit','active','disabled')#">Edit</span>
        </li>
    </ul>
    <div class="tab-content">
        <div class="tab-pane fade show active" id="searchForm" role="tabpanel" aria-labelledby="home-tab">
            #view("transactionSearch/_searchForm",{
                resultsTab: "##",
                resultsDiv: "searchResults"
            })#
        </div>
        <div class="tab-pane fade" id="searchResults" role="tabpanel" aria-labelledby="profile-tab">
        </div>
        <div class="tab-pane fade" id="edit" role="tabpanel" aria-labelledby="contact-tab">...</div>
    </div>

</cfoutput>