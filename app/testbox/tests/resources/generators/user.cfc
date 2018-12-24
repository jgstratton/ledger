component user{

    public component function init(){
        var user = EntityLoad("user",{username: "testUser"},true);
        if (isNull(user)) {
            user = EntityNew("user",{username:"testUser"});
            user.save();
        }
		return user;
    }

    
}