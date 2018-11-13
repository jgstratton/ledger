component accessors=true  {
	property beanFactory;
	property transactionService;
	property categoryService;
	property accountService;
	
	property name="fromAccount" type="component";
    property name="toAccount" type="component";
    property name="amount";
    property name="name";
	property name="transferDate";
	property name="fromTransaction" type="component";

	
	public any function init() {
		variables.beanFactory = application.beanFactory;
		variables.transactionService = beanFactory.getBean("TransactionService");
		variables.categoryService = beanFactory.getBean("categoryService");
		variables.accountService = beanFactory.getBean("accountService");
	}

	public void function populateFromTransaction(any fromTransaction){
		setFromTransaction( arguments.fromTransaction );
		setFromAccount( arguments.fromTransaction.getAccount() );
		setToAccount( arguments.fromTransaction.getLinkedTo().getAccount() );
		setAmount( arguments.fromTransaction.getAmount() );
		setName( arguments.fromTransaction.getName() );
		setTransferDate( arguments.fromTransaction.getTransactionDate() );
	}

	public void function save(){
		if ( isPersisted() ) {
			var toTransaction = getFromTransaction().getLinkedTo();
			var fromTransaction = getFromTransaction();
		} else {
			var toTransaction = new beans.transaction();
			var fromTransaction = new beans.transaction();
		}

		fromTransaction.setAccount( getFromAccount() );
		toTransaction.setAccount( getToAccount() );
		fromTransaction.setAmount( getAmount() );
		toTransaction.setAmount( getAmount() );
		fromTransaction.setName( getName() );
		toTransaction.setName( getName() );
		fromTransaction.setTransactionDate( getTransferDate() );
		toTransaction.setTransactionDate( getTransferDate() );
		fromTransaction.setCategory( categoryService.getCategoryByName('Transfer From') );
		toTransaction.setCategory( categoryService.getCategoryByName('Transfer Into') );

		transaction{
			transactionService.save(fromTransaction);
			transactionService.save(toTransaction);
			fromTransaction.setLinkedTo(toTransaction);
		}
	}

	public number function getFromAccountID(){
		if (isDefined('variables.fromAccount')) {
			return JavaCast('int',getFromAccount().getId());
		}
		return 0;
	}

	public number function getToAccountId() {
		if (isDefined('variables.toAccount')) {
			return JavaCast('int',getToAccount().getId());
		}
		return 0;
	}

	public void function setFromAccountId(numeric id){
		if(arguments.id > 0){
			setFromAccount( accountService.getAccountById(arguments.id) );
		}
	}
	
	public void function setToAccountId(numeric id){
		if(arguments.id > 0){
			setToAccount( accountService.getAccountById(arguments.id) );
		}
	}

	private boolean function isPersisted() {
		if ( isDefined('variables.fromTransaction') ){
			return true;
		}
		return false;
	}

}
