component user{
    
    public component function init(){
        variables.mockBox = new testbox.system.MockBox();
        return this;
    }

    public component function generate(){
        mockedUser = mockBox.createMock( "beans.user" );
        mockedUser.$property(propertyName="checkbookSummaryService", mock = new services.checkbookSummary());
        mockedUser.$property(propertyName="cached", mock = structNew());
        mockedUser.setUsername("testUser");
        mockedUser.save();
		return mockedUser;
    }

    
}