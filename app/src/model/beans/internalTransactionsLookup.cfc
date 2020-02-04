/**
 * This is just a lookup view to find internal transfers (transfers from within the same parent account)
 **/
component persistent="true" table="vw_internal_transfers" accessors="true" entityName="internalTransfer" extends="_entity" {
    property name="user_id" ormtype="integer";
	property name="transactionId1" fieldtype="id";
	property name="transactionId2" fieldtype="id";
}

