<cfoutput>
	#view("includes/alerts")#
	
	<cfif structKeyExists(rc, "loginError")>
		<div class="alert alert-danger alert-dismissible fade show" role="alert">
			<strong>Error!</strong> #rc.loginError#
			<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
	</cfif>
	
	<cfif rc.keyExists("showEmailForm")>
		<form method="post" action="#buildurl('auth.login')#">
			<input type="hidden" name="email_auth" value="1">
			<div class="form-group">
				<label for="email">Email address</label>
				<input type="email" class="form-control" id="email" name="email" placeholder="Enter email" required>
			</div>
			<button type="submit" class="btn btn-primary">Send Link</button>
		</form>
	<cfelseif Not Session.Loggedin>
		<p class="text-info">
			Welcome to <b>My Checkbook</b>!
		</p>
		<p>
			<a class="btn btn-primary" href="#buildurl('auth.login?startfb=1')#"><i class="fa fa-facebook-square"></i> Login with Facebook</a>
		</p>
		<p>
			<a class="btn btn-primary" href="#buildurl('auth.login?email_auth=1')#"><i class="fa fa-envelope"></i> Login with Email</a>
		</p>
	<cfelse>
		You are logged in:
		<a href="#buildurl("auth.logout")#">Log out</a>
	</cfif>
</cfoutput>