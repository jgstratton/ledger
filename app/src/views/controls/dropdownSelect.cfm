<cfparam name="local.containerClass" default="">
<cfparam name="local.name" default="#local.templateId#">
<cfparam name="local.id" default="#local.templateId#">
<cfparam name="local.options" type="array" required="true">

<cfset local.noTemplateWrappers = true>
<cfset local.containerId = "dropDownSelect_#local.id#">

<cfoutput>
	<div id="#local.containerId#" class="#local.containerClass#">
		<input id="#local.id#" type="hidden" name="#local.name#" value="#local.options[1].value#" data-drop-value>
		<button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown" data-drop-display>#local.options[1].display#</button>
		<div class="dropdown-menu">
			<cfloop array="#local.options#" index="local.option">
				<a class="dropdown-item" data-option-value="#local.option.value#" href="##">#local.option.display#</a>
			</cfloop>
		</div>
	</div>

	<script>
		viewScripts.add( function(){
			var $container = $('###local.containerId#');
			$container.find('[data-option-value]').click(function(){
				$container.find('[data-drop-display]').html($(this).html());
				$container.find('[data-drop-value]').val($(this).data('optionValue'));
				$container.find('[data-drop-value]').trigger('change');
			});
		});
	</script>

</cfoutput>