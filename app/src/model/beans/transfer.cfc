component accessors=true  {
	property beanFactory;
	property transactionService;
	property categoryService;
	property accountService;
	property checkbookSummaryService;
	
	property name="fromAccount" type="component";
    property name="toAccount" type="component";
    property name="amount";
    property name="name";
	property name="transferDate";
	property name="fromTransaction" type="component";
	property name="toTransaction" type="component";
	
	public any function init() {
		variables.beanFactory = application.beanFactory;
		variables.transactionService = beanFactory.getBean("TransactionService");
		variables.categoryService = beanFactory.getBean("categoryService");
		variables.accountService = beanFactory.getBean("accountService");
		variables.checkbookSummaryService = beanFactory.getBean("checkbookSummaryService");
	}

	public void function populateFromTransaction(any fromTransaction){
		setFromTransaction( arguments.fromTransaction );
		setFromAccount( arguments.fromTransaction.getAccount() );
		setToAccount( arguments.fromTransaction.getLinkedTo().getAccount() );
		setAmount( arguments.fromTransaction.getAmount() );
		setName( arguments.fromTransaction.getName() );
		setTransferDate( dateformat(arguments.fromTransaction.getTransactionDate(),"mm/dd/yyyy") );
	}

	public void function save(){
		prepareSave();
		transaction{
			transactionService.saveTransaction(getFromTransaction());
			transactionService.saveTransaction(getToTransaction());	
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
		if ( !isNull(getFromTransaction())) {
			return true;
		}
		return false;
	}

	private void function prepareSave(){
		if ( isPersisted() ) {
			var toTransaction = getFromTransaction().getLinkedTo();
			var fromTransaction = getFromTransaction();
		} else {
			var toTransaction = transactionService.createEmptyTransaction();
			var fromTransaction = transactionService.createEmptyTransaction();
		}
		setFromTransaction(fromTransaction);
		setToTransaction(toTransaction);
		
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
		fromTransaction.setLinkedTo(toTransaction);

		if (accountService.hasCommonParent( getFromAccount(), getToAccount()) ) {
			fromTransaction.setVerifiedDate(now());
			toTransaction.setVerifiedDate(now());
		}

	}

}
