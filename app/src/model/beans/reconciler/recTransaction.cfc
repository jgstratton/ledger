component accessors="true" extends="abstract.reconciler.aRecTransaction" {
	property name="id" type="string";
	property name="data" type="struct";

	public void function populate(required struct)	
}