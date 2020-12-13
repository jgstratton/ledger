<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">
		<cfquery>
			CREATE OR REPLACE VIEW vw_internal_transfers AS
			SELECT 
				a1.user_id, 
				t1.id as transactionId1, 
				t2.id as transactionId2
			FROM transactions t1
			INNER JOIN transactions t2
				ON t1.id = t2.linkedTransId
			INNER JOIN accounts a1
				on t1.account_id = a1.id
			INNER JOIN accounts a2 
				ON t2.account_id = a2.id
			WHERE 
				(a1.id = a2.linkedaccount) 
				OR (a2.id = a1.linkedaccount) 
				OR (a1.linkedAccount = a2.linkedAccount)
		</cfquery>
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">
		<cfquery>
			Drop view if exists vw_internal_transfers;
		</cfquery>
	</cffunction>
</cfcomponent>