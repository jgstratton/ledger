<h1>An Error Occurred</h1>
<p>Details of the exception:</p>
<cfoutput>
	<ul>
		<li>Failed action:
          <cfif structKeyExists( request, 'failedAction' )>
            <!--- sanitize user supplied value before displaying it --->
            #replace( request.failedAction, chr(60), "&lt;", "all" )#
          <cfelse>
            unknown
          </cfif>
        </li>
		<li>Application event: #request.event#</li>
		<li>Exception type: #request.exception.type#</li>
		<li>Exception message: #request.exception.message#</li>
		<li>Exception detail: #request.exception.detail#</li>
	</ul>
    <p>Back to the <a href="#buildURL('main')#">default page</a>?</p>
</cfoutput>

<cfif StructKeyExists(request.exception,'cause')>
  <cfif structKeyExists(request.exception.cause,'TagContext')>
    <cfset Context = request.exception.cause.TagContext>
    <cfoutput>
      <cfset CurTemplate = "">
      <cfloop from="1" to="#arraylen(Context)#" index="i">
        <cfif Context[i].template neq curTemplate>
          <cfset curTemplate = Context[i].template>
          <h4>#curTemplate#</h4>
        </cfif>
        <pre>#Context[i].CodePrintHTML#</pre>
      </cfloop>
  </cfoutput>
  </cfif>
</cfif>
<hr>
<cfdump var="#request.exception#">




