component name="auth" output="false"  accessors=true {
	property userService;
	property alertService;
	property loggerService;
	property authenticatorService;

	facebook = application.facebook;

	public void function init(fw){
		variables.fw = arguments.fw;
	}

	/**
	 * Use the proxy login trying to log in via proxy (like from a node front end)
	 */
	public void function proxyLogin ( struct rc = {} ) {
		loggerService.debug("Starting login via proxy");
		multiStepLogin(rc, true);
	}

	public void function login( struct rc = {} ) {
		if (rc.keyExists('email_auth')) {
			loginByEmail(rc);
			if (session.loggedin) {
				location("#application.root_path#", false);
			}
			return;
		}
		multiStepLogin(rc, false);
	}

	private void function loginByEmail( struct rc = {} ) {
		// Check if this is the initial request (user enters email) or verification (clicking magic link)
		if (structKeyExists(rc, 'token')) {
			verifyMagicLink(rc);
		} else if (structKeyExists(rc, 'email') && len(trim(rc.email))) {
			sendMagicLink(rc.email);
		} else {
			// Show the form to enter email
			rc.showEmailForm = true;
		}
	}

	public void function adminLogin(struct rc = {}) {
		if (rc.keyExists('user_id') && rc.keyExists('adminKey') && rc.adminKey == application.adminKey) {
			session.userid = user_id;
			session.loggedin = true;

			sg = new sendgrid.sendgrid(application.sendgrid.key);
			mail = new sendgrid.helpers.mail()
			.from( application.sendgrid.fromEmail )
			.subject( 'Admin login into checkbook' )
			.to( application.sendgrid.toEmail )
			.plain( 'Admin login used to access account #rc.user_id#');

			sg.sendMail(mail);
		}
	}

	private void function multiStepLogin( struct rc = {}, boolean isProxy = false) {

		//if user clicked the log into facebook link, then redirect them to the fb login
		if(structKeyExists(rc, 'startfb' )){
			startFacebookLogin(isProxy);
		}

		/*  if the user is returning from the facebook login, log them in
			Create the user record if it doesn't exsist yet*/
		if( structKeyExists(rc, 'code' )  and rc.state is session.state  ){
			local.fbToken = facebook.getAccessToken(rc.code);
		} else if(structKeyExists(cookie,'fbToken')){
			local.fbToken = cookie.fbToken;
		}      

		//if the token is set, then log in the user.
		if(structKeyExists(local,"fbToken")){
		  completeFacebookLogin(local.fbToken);
		}
	}

	//Set session variables and navigate to facebook auth url
	private void function startFacebookLogin(boolean isProxy = false) {
		session.state = createUUID();
		session.loginByProxy = false;
		if(isProxy) {
			session.loginByProxy = true;
			session.logInSource = cgi.HTTP_REFERER;
		}
		var faceBookAuthUrl = "#facebook.getAuthURL("email",session.state)#";
		loggerService.debug(faceBookAuthUrl);
		location url=faceBookAuthUrl;
	}

	//log in user (via facebook authentication)
	private void function completeFacebookLogin(required string fbToken) {
		cfparam (name="session.loginByProxy", default="false");
		var fbUser = variables.facebook.getMe(fbToken);

		//if the token doesn't contain an id, it's no good.  Log the user out
		if (!fbUser.keyExists('id')) {
			logout();
			return;
		}

		var username = fbUser.id;
		 
		if (fbUser.keyExists('email')) {
			username = fbUser.email;
		}

		session.userid = variables.userService.getOrCreate( username ).getId();
		session.loggedin = true;

		cfcookie(
			name="fbtoken"
			value="#fbToken#"
			expires="30");
		
		if(session.loginByProxy) {
			loggerService.debug("navigating to #session.loginSource#");
			location("#session.logInSource#",false);
		} else {
			location("#application.root_path#",false);
		}
	}

	public void function logout( struct rc = {} ){
		authenticatorService.logout();
		alertService.setTitle("success","You have sucessfully been logged out.");
		variables.fw.redirect("auth.login");
	}

	private void function sendMagicLink(required string email) {
		try {
			// Generate a secure token
			var token = hash(createUUID() & now() & email, "SHA-256");
			var expiresAt = dateAdd("h", 1, now()); // Token valid for 1 hour
			
			// Store token in session or database (using session for simplicity)
			session.magicLinkToken = {
				token: token,
				email: email,
				expiresAt: expiresAt
			};
			
			// Create magic link URL
			var magicLinkUrl = "#application.root_path#?action=auth.login&email_auth=1&token=#token#";
			
			// Send email via SendGrid
			var sg = new sendgrid.sendgrid(application.sendgrid.key);
			var mail = new sendgrid.helpers.mail()
				.from(application.sendgrid.fromEmail)
				.subject("Sign in to Checkbook")
				.to(email)
				.html('
					<h2>Sign In to Checkbook</h2>
					<p>Click the link below to sign in. This link will expire in 1 hour.</p>
					<p><a href="#magicLinkUrl#" style="background-color: ##4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block;">Sign In</a></p>
					<p>Or copy and paste this link into your browser:</p>
					<p>#magicLinkUrl#</p>
					<p>If you didn''t request this email, you can safely ignore it.</p>
				')
				.plain('Sign in to Checkbook. Click or copy this link: #magicLinkUrl#. This link expires in 1 hour.');
			
			sg.sendMail(mail);
			
			alertService.setTitle("success", "Check your email! We've sent you a magic link to sign in.");
			loggerService.debug("Magic link sent to: #email#");
			
		} catch (any e) {
			loggerService.error("Error sending magic link: #e.message#", e);
			alertService.setTitle("error", "Failed to send magic link. Please try again.");
		}
		
		variables.fw.redirect("auth.login");
	}

	private void function verifyMagicLink(required struct rc) {
		try {
			// Check if token exists in session
			if (!structKeyExists(session, "magicLinkToken")) {
				rc.loginError = "No magic link token found";
				throw(type="InvalidToken", message="No magic link token found");
			}
			
			var storedToken = session.magicLinkToken;
			
			// Verify token matches
			if (rc.token != storedToken.token) {
				throw(type="InvalidToken", message="Token mismatch");
			}
			
			// Check if token has expired
			if (now() > storedToken.expiresAt) {
				throw(type="ExpiredToken", message="Token has expired");
			}
			
			// Token is valid - log in the user
			session.userid = variables.userService.getOrCreate(storedToken.email).getId();
			session.loggedin = true;
			
			// Clear the used token
			structDelete(session, "magicLinkToken");
			
			loggerService.debug("User logged in via magic link: #storedToken.email#");
			alertService.setTitle("success", "Welcome! You've successfully signed in.");
			
		} catch (any e) {
			loggerService.error("Magic link verification failed: #e.message#", e);
			alertService.setTitle("error", "Invalid or expired magic link. Please request a new one.");
			
			// Clear invalid token
			structDelete(session, "magicLinkToken");
		}
	}
}
