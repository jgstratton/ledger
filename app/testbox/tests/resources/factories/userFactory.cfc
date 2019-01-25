component user{
    
    public component function getTestUser() {
        var user = EntityLoad("user",{username = 'testUser'});
        if (user.len()) {
            return user[1];
        }
        var user = new beans.user();
        user.setUserName("testUser");
        user.save();
        return user;
    }
}