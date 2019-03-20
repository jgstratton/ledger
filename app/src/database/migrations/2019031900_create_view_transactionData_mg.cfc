<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

        <cfquery>
            ALTER TABLE transactions
            ADD UNIQUE FK_transactions_linkedTransId (linkedTransId) USING BTREE;
        </cfquery>
       
        <cfquery>
            ALTER TABLE transactions
            ADD INDEX IX_transactions_transactionDate (transactionDate);
        </cfquery>

		<cfquery>
            CREATE OR REPLACE VIEW vw_transactionData AS
            SELECT
                t.id AS id,
                t.amount * cType.multiplier AS SignedAmount,
                t.account_id,
                a.name as account_name,
                t.category_id,
                c.name as category_name,
                coalesce(linkedTo.id, linkedFrom.id) AS linkedTransId,
                CASE 
                    WHEN not isNull(linkedTo.id) THEN 'FROM'
                    WHEN NOT isNUll(linkedFrom.id) THEN 'TO'
                    ELSE NULL
                END AS transferType,
                coalesce(linkedToAccount.id, linkedFromAccount.id) as linkedAccountId,
                coalesce(linkedToAccount.name, linkedFromAccount.name) as linkedAccountName,
                linkedFrom.id AS linkedFromId,
                t.name,
                t.transactionDate,
                t.amount,
                t.note,
                t.verifiedDate,
                t.created,
                t.edited,
                t.isHidden

            FROM transactions t
            INNER JOIN categories c on t.category_id = c.id
            INNER JOIN categoryTypes cType on c.categoryType_id = cType.id
            INNER JOIN accounts a
                ON t.account_id = a.id
            LEFT JOIN transactions linkedTo
            on t.linkedTransId = linkedTo.id
            LEFT JOIN accounts linkedToAccount 
                ON linkedTo.account_id = linkedToAccount.id
            LEFT JOIN transactions linkedFrom
                on linkedFrom.linkedTransId = t.id
            LEFT JOIN accounts linkedFromAccount
                ON linkedFrom.account_id = linkedFromAccount.id

		</cfquery>

	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop view if exists vw_transactionData;
		</cfquery>

        <cfquery>
            ALTER TABLE transactions DROP INDEX IX_transactions_transactionDate;
        </cfquery>

        <cfquery>
            ALTER TABLE transactions DROP INDEX FK_transactions_linkedTransId;
        </cfquery>
	</cffunction>
</cfcomponent>