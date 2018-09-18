<cfcomponent output="true" extends="migration_base">

    <cfset this.accounts = [
        {
            name: "Primary Checking Account", 
            accountType: 1, 
            summary: "Y",
            transactions: [
                { name: "Paycheck", datediff: "-30", amount="1723.42", note="", categoryid="13"},
                { name: "Sheetz", datediff: "-29", amount="28.54", note="Gas", categoryid="2"}
            ]
        },
        {   name: "Home Checking Account", 
            accountType: 1, 
            summary: "Y",
            transactions: [
                { name: "Deposit", datediff: "-30", amount="425.00", note="", categoryid="14"},
                { name: "Mortgage Payment", datediff: "-25", amount="650.00", note="", categoryid="1"}
            ]
        }
    ]>

    <cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
        returntype="void">

            <cfset local.user_email = createObject( "java", "java.lang.System" ).getenv( "DEFAULT_USER_EMAIL")>

            <cfset var account = {}>
            <cfset var transaction = {}>

            <!--- Add Default Test User using env variable --->
            <cfquery name="qryInsertUser" datasource="#this.datasource#">
                Insert into users (username, email)
                Values ('#local.user_email#', '#local.user_email#')
            </cfquery>

            <cfloop from="1" to="#arraylen(this.accounts)#" index="local.i">
                <cfset account = this.accounts[local.i]>
                
                <cfquery datasource="#this.datasource#">
                    Insert Into accounts(name, accountType_id, summary, user_id) 
                    values(<cfqueryparam value="#account.name#">, <cfqueryparam value="#account.accountType#">, <cfqueryparam value="#account.summary#">,1) 
                </cfquery>
                
                <cfloop from="1" to="#arraylen(account.transactions)#" index="local.j">
                    <cfset transaction = account.transactions[local.j]>
                    <cfquery datasource="#this.datasource#">
                        Insert into transactions (name, transactiondate, amount, note, account_id, category_id)
                        values ('#transaction.name#', date_add(now(), INTERVAL #transaction.datediff# DAY), #transaction.amount#,'#transaction.note#',#local.i#, #transaction.categoryid#)
                    </cfquery>
                </cfloop>
            
            </cfloop>

    </cffunction>

    <cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
        returntype="void">
            <!--- Delete seeds... for now, just delete everthing.  We can get more sophisticated (if needed) later. --->
            <cfquery datasource="#this.datasource#">
                Delete from users
            </cfquery>

            <cfquery datasource="#this.datasource#">
                Delete from accounts
            </cfquery>

            <cfquery datasource="#this.datasource#">
                Delete from transactions
            </cfquery>

    </cffunction>

</cfcomponent>
