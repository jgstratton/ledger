component accessors=true  {
	property transferService;
	property transactionService;
	property categoryService;

	property name="fromAccount" type="component";
    property name="toAccount" type="component";
    property name="amount" type="numeric";
    property name="name" type="string";
	property name="transactionDate" type="date";
	property name="fromTransaction" type="component";

	
	public any function init(any fromTransaction) {
		if(arguments.keyExists('fromTransaction')){
			populateFromTransaction(arguments.fromTransaction);
		}
	}

	public void function populateFromTransaction(any fromTransaction){
		this.fromTransaction = arguments.fromTransaction;
		this.fromAccount = this.fromTransaction.getAccount();
		this.toAccount = this.fromTransaction.getLinkedTo().getAccount();
		this.amount = this.fromTransaction.getAmount();
		this.name = this.fromTransaction.getName();
		this.transactionDate = this.fromTransaction.getTransactionDate();
	}

	public void function save(){
		var toTransaction = this.fromTransaction.getLinkedTo();
		var fromTransaction = this.fromTransaction;

		fromTransaction.setAccount( this.fromAccount );
		toTransaction.setAccount( this.toAccount );
		fromTransaction.setAmmount( this.amount );
		toTransaction.setAmount( this.amount );
		fromTransaction.setName( this.name );
		toTransaction.setName( this.name );
		fromTransaction.setTransactionDate( this.transactionDate );
		toTransaction.setTransactionDate( this.transactionDate );
		fromTransaction.setCategory( categoryService.getCategoryByName('Transfer From') );
		toTransaction.setCategory( categoryService.getCategoryByName('Transfer Into') );

		transaction{
			transactionService.saveTransaction(fromTransaction);
			transactionService.saveTransaction(toTransaction);
		}
	}



}
