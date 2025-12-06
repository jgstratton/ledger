<cfoutput>
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    Manage Accounts
                    <div class="float-right">
                        <a href="#buildUrl('account.list')#" class="btn btn-sm btn-secondary">Back to List</a>
                    </div>
                </div>
                <div class="card-body">
                    <form action="#buildUrl('account.updateStatus')#" method="post">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Account</th>
                                    <th>Type</th>
                                    <th>Balance</th>
                                    <th>Disabled</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop array="#rc.accounts#" index="account">
                                    <tr>
                                        <td>#account.getName()#</td>
                                        <td>#account.getType().getName()#</td>
                                        <td>#moneyFormat(account.getBalance())#</td>
                                        <td>
                                            <input type="checkbox" name="accountIds" value="#account.getId()#" <cfif account.getDisabled()>checked</cfif>>
                                        </td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </table>
                        <button type="submit" name="submitManage" class="btn btn-primary">Save Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</cfoutput>