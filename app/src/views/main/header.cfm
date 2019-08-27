<cfoutput>
    <div class="center-content">
        <div class="bg-dark d-flex">
            <button class="navbar-toggler collapsed" type="button" data-toggle="collapse" data-target="##navbar">
                <i class="fa fa-bars"></i>
            </button>
            <span class="navbar-brand">
                My checkbook
            </span>
            <div class="text-right flex-nowrap d-flex d-md-none text-secondary">
                Summary - <span class="badge badge-primary text-nowrap">#moneyFormat(rc.user.getSummaryBalance())#</span>
            </div>
            <div class="text-right d-none d-md-inline text-secondary">
                Checkbook Summary - <span class="badge badge-primary">#moneyFormat(rc.user.getSummaryBalance())#</span>
            </div>
        </div>
        #view('main/navbar')#
</div>

</cfoutput>