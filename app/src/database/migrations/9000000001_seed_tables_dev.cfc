<cfcomponent output="true" extends="migration_base">

    <cfset this.accounts = [
        {
            name: "USSCO Checking Account", 
            accountType: 1, 
            summary: "Y",
            transactions: [
                { name: "Paycheck", datediff: "-30", amount="1723.42", note="", categoryid="14", verified="Y"},
                { name: "Sheetz", datediff: "-29", amount="28.54", note="Gas", categoryid="3", verified="Y"},
                { name: "Natual Gas Bill", datediff: "-28", amount="127.25", note="", categoryid="13", verified="N"},
                { name: "Netflix", datediff: "-27", amount="12.00", note="", categoryid="20", verified="N"},
                { name: "Christmas Club", datediff: "-15", amount="250", note="", categoryid="22", verified="N", transfer="1"},
                { name: "Credit Card Payment", datediff: "-9", amount="25", note="", categoryid="22", verified="N", transfer="2"}
            ]
        },
        {
            name: "Secondary Checking", 
            accountType: 1, 
            summary: "Y"
        },
        {   name: "Chase (Amazon)", 
            accountType: 2, 
            summary: "Y",
            transactions: [
                { name: "Deposit", datediff: "-30", amount="425.00", note="", categoryid="15", verified="Y"},
                { name: "Mortgage Payment", datediff: "-25", amount="650.00", note="", categoryid="2", verified="N"},
                { name: "Credit Card Payment", datediff: "-9", amount="25", note="", categoryid="23", verified="N", transfer="2"}
            ]
        },
        {   name: "Car Loan", 
            accountType: 3, 
            summary: "N",
            transactions: [
                { name: "Loan Amount", datediff: "-365", amount="11000", note="", categoryid="22", verified="Y"},
                { name: "Payment", datediff: "-335", amount="325.00", note="", categoryid="23", verified="Y"},
                { name: "Payment", datediff: "-301", amount="325.00", note="", categoryid="23", verified="Y"},
                { name: "Payment", datediff: "-290", amount="325.00", note="", categoryid="23", verified="Y"},
                { name: "Payment", datediff: "-256", amount="325.00", note="", categoryid="23", verified="N"}
            ]
        },
        {
            name: "Spare Change", 
            accountType: 6, 
            summary: "N",
            linkedAccount:1,
            userRoundAccount:true
        },
        {
            name: "Christmas Club", 
            accountType: 6, 
            summary: "N",
            linkedAccount:1,
            transactions: [
                { name: "Christmas Club", datediff: "-25", amount="200", note="", categoryid="23", verified="Y", transfer="1"}
            ]
        },
        {
            name: "Vacation Fund", 
            accountType: 6, 
            summary: "N",
            linkedAccount:1,
            transactions: [
                { name: "Vacation", datediff: "-25", amount="150", note="", categoryid="22", verified="Y"}
            ]
        },
    ]>

    <cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
        returntype="void">

            <cfset local.user_email = createObject( "java", "java.lang.System" ).getenv( "DEFAULT_USER_EMAIL")>

            <cfset var account = {}>
            <cfset var transaction = {}>
            <cfset var transfers = {}>
            
            <!--- Add Default Test User using env variable --->
            <cfquery name="qryInsertUser">
                Insert into users (username, email)
                Values ('#local.user_email#', '#local.user_email#')
            </cfquery>

            <cfloop from="1" to="#arraylen(this.accounts)#" index="local.i">
                <cfset account = this.accounts[local.i]>
                
                <cfquery>
                    Insert Into accounts(name, accountType_id, summary, user_id, LinkedAccount) 
                    values(<cfqueryparam value="#account.name#">, <cfqueryparam value="#account.accountType#">, <cfqueryparam value="#account.summary#">,1,
                        <cfif StructKeyExists(account,"linkedaccount")>
                            #account.linkedAccount#
                        <cfelse>
                            NULL
                        </cfif>
                    ) 
                </cfquery>
                
                <cfif StructKeyExists(account,'userRoundAccount')>
                    <cfquery>
                        Update users 
                        Set roundingAccount_id = #local.i#,
                            roundingModular = 5
                        Where id = 1 
                    </cfquery>
                </cfif>
                <cfif StructKeyExists(account,"transactions")>
                    <cfloop from="1" to="#arraylen(account.transactions)#" index="local.j">
                        <cfset var transaction = account.transactions[local.j]>
                        <cfquery result="last_transaction">
                            Insert into transactions (name, transactiondate, amount, note, account_id, category_id,verifiedDate)
                            values (
                                '#transaction.name#', 
                                date_add(now(), INTERVAL #transaction.datediff# DAY), 
                                #transaction.amount#,
                                '#transaction.note#',
                                #local.i#, 
                                #transaction.categoryid#,
                                <cfif transaction.verified eq 'Y'>
                                    date_add(now(), INTERVAL #transaction.datediff# DAY)
                                <cfelse>
                                    NULL
                                </cfif>
                            )
                        </cfquery>
                        <cfif transaction.keyExists("transfer")>
                            <cfif not transfers.keyExists(transaction.transfer)>
                                <cfset transfers[transaction.transfer] = StructNew()>
                            </cfif>
                            <cfif transaction.categoryid eq 22>
                                <cfset transfers[transaction.transfer].fromTransaction = last_transaction.generatedKey>
                            <cfelseif transaction.categoryid eq 23>
                                <cfset transfers[transaction.transfer].toTransaction = last_transaction.generatedKey>
                            <cfelse>
                                <cfthrow message="Invalid transfer category type">
                            </cfif>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfloop>

            <!--- loop through the transactions and generate the records --->
            <cfloop list="#structKeylist(transfers)#" index="i">
                <cfquery>
                    Update transactions
                    set linkedTransId = #transfers[i].toTransaction#
                    where id = #transfers[i].fromTransaction#
                </cfquery>
            </cfloop>

            <!--- Add all categories for this user --->
            <cfquery>
                Insert into userCategories(category_id, user_id)
                Select id, 1
                from categories
            </cfquery>
    </cffunction>

    <cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
        returntype="void">
            <!--- Delete seeds... for now, just delete everthing.  We can get more sophisticated (if needed) later. --->
            <cfquery>
                Delete from users
            </cfquery>

            <cfquery>
                Delete from accounts
            </cfquery>

            <cfquery>
                Delete from transactions
            </cfquery>

    </cffunction>

</cfcomponent>
