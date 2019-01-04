component displayName="Transfer Service Unit Tests" extends="testbox.system.BaseSpec" {
    
    function hideFromTransactionTest() {
        transferService = new services.transfer();

        transfer = createMock("beans.transfer");
        transfer.setFromTransaction( new beans.transaction());

        transferService.hideFromTransaction(transfer);
        
        $assert.isEqual(1, transfer.getFromTransaction().isHidden());
        
    }
}