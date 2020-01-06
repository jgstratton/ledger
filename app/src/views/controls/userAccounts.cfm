<cfparam name="local.accountsInput" required="true">
<cfparam name="local.linkedInput" required="true">

<cfoutput>
	<div class="row">
		<div class="col-8">
			<select name="#local.accountsInput.getName()#" class="form-control form-control-sm" multiple="multiple">
				<cfloop array="#local.accountsInput.getOptions()#" item="option">
					<option value="#option.value#" #matchSelect(option.value, local.accountsInput.getValue())#>
						#option.text#
					</option>
				</cfloop>
			</select> 
		</div>
		<div class="col-4">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" value="1" name="#local.linkedInput.getName()#">
				<label class="form-check-label" for="#local.linkedInput.getName()#">
					Include Linked
				</label>
			</div>
		</div>
	</div>
	<script>
		$("[name='#local.accountsInput.getName()#']").multipleSelect();
	</script>
</cfoutput>
