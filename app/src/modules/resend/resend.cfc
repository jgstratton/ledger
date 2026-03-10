/**
 * resend.cfc
 * A lightweight CFML wrapper for the Resend email API (https://resend.com/docs)
 */
component output="false" displayname="Resend.cfc" {

	public any function init(
		string apiKey = '',
		string baseUrl = "https://api.resend.com",
		numeric httpTimeout = 50
	) {
		structAppend( variables, arguments );

		// Check environment variable if apiKey not provided
		if ( !variables.apiKey.len() ) {
			var system = createObject( 'java', 'java.lang.System' );
			var envValue = system.getenv( 'RESEND_API_KEY' );
			if ( !isNull( envValue ) && envValue.len() ) {
				variables.apiKey = envValue;
			}
		}

		return this;
	}

	/**
	 * Send an email via Resend's API
	 * @from Sender email address (e.g. "Name <email@example.com>" or "email@example.com")
	 * @to Recipient email address or array of addresses
	 * @subject Email subject line
	 * @html HTML body content (optional if text is provided)
	 * @text Plain text body content (optional if html is provided)
	 * @cc CC recipients (string or array)
	 * @bcc BCC recipients (string or array)
	 * @replyTo Reply-to email address
	 * @tags Array of tag structs with name/value keys
	 */
	public struct function sendEmail(
		required string from,
		required any to,
		required string subject,
		string html = '',
		string text = '',
		any cc = '',
		any bcc = '',
		string replyTo = '',
		array tags = []
	) {
		var body = {
			"from": arguments.from,
			"to": isArray( arguments.to ) ? arguments.to : [ arguments.to ],
			"subject": arguments.subject
		};

		if ( arguments.html.len() ) body[ "html" ] = arguments.html;
		if ( arguments.text.len() ) body[ "text" ] = arguments.text;
		if ( isArray( arguments.cc ) ? arrayLen( arguments.cc ) : arguments.cc.len() ) body[ "cc" ] = isArray( arguments.cc ) ? arguments.cc : [ arguments.cc ];
		if ( isArray( arguments.bcc ) ? arrayLen( arguments.bcc ) : arguments.bcc.len() ) body[ "bcc" ] = isArray( arguments.bcc ) ? arguments.bcc : [ arguments.bcc ];
		if ( arguments.replyTo.len() ) body[ "reply_to" ] = arguments.replyTo;
		if ( arrayLen( arguments.tags ) ) body[ "tags" ] = arguments.tags;

		return apiCall( 'POST', '/emails', body );
	}

	/**
	 * @hint Makes the HTTP request to the Resend API
	 */
	private struct function apiCall(
		required string httpMethod,
		required string path,
		required struct body
	) {
		var result = {};
		var fullUrl = variables.baseUrl & arguments.path;
		var requestBody = serializeJSON( arguments.body );

		cfhttp(
			url = fullUrl,
			method = arguments.httpMethod,
			timeout = variables.httpTimeout,
			result = "httpResult"
		) {
			cfhttpparam( type = "header", name = "Authorization", value = "Bearer #variables.apiKey#" );
			cfhttpparam( type = "header", name = "Content-Type", value = "application/json" );
			cfhttpparam( type = "body", value = requestBody );
		}

		try {
			result = deserializeJSON( httpResult.fileContent );
		} catch ( any e ) {
			result = {
				"error": true,
				"message": "Failed to parse response",
				"raw": httpResult.fileContent,
				"statusCode": httpResult.statusCode
			};
		}

		result[ "statusCode" ] = httpResult.statusCode;

		// Throw on non-2xx status codes so callers can catch failures
		var statusCode = val( httpResult.statusCode );
		if ( statusCode < 200 || statusCode >= 300 ) {
			var errorMessage = result.keyExists( 'message' ) ? result.message : httpResult.fileContent;
			throw(
				type = "ResendApiError",
				message = "Resend API error (HTTP #httpResult.statusCode#): #errorMessage#",
				detail = serializeJSON( result )
			);
		}

		return result;
	}

}
