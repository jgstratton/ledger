<cfparam name="local.accountsInput">
<cfparam name="local.linkedInput" default="">
<cfparam name="local.parentAccountsOnly" default="false">

<cfset local.hasLinked = isObject('local.linkedInput') ? true : false>
<cfif parentAccountsOnly>
	<cfset local.accountsInput.removeChildAccounts()>
</cfif>

<cfoutput>
	<div class="row">
		<div class="col-#(local.hasLinked ? 8 : 12)#">
			<select name="#local.accountsInput.getName()#" class="form-control form-control-sm" multiple="multiple">
				<cfloop array="#local.accountsInput.getOptions()#" item="option">
					<option value="#option.value#" #matchSelect(option.value, local.accountsInput.getValue())#>
						#option.text#
					</option>
				</cfloop>
			</select> 
		</div>
		<cfif local.hasLinked>
			<div class="col-4">
				<div class="form-check">
					<input class="form-check-input" type="checkbox" value="1" name="#local.linkedInput.getName()#">
					<label class="form-check-label" for="#local.linkedInput.getName()#">
						Include Linked
					</label>
				</div>
			</div>
		</cfif>
	</div>
	<script>
		$("[name='#local.accountsInput.getName()#']").multipleSelect();
	</script>
</cfoutput>
