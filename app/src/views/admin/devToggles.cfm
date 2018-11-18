<cfoutput>
    <form name="frmDevToggles" method="post">
        <table class="table">
            <thead>
                <tr>
                    <th>Toggle Name</th>
                    <th>Enabled</th>
                    <th>Disabled</th>
                </tr>
            </thead>
            <tbody>
                <cfloop list="showTemplateWrappers" index="toggleName">
                    <tr>
                        <th>#toggleName#</th>
                        <td><input type="radio" name="#toggleName#" value="true" #checkif(rc.toggles[toggleName])#></td>
                        <td><input type="radio" name="#toggleName#" value="false" #checkif(!rc.toggles[toggleName])#></td>
                    </tr>
                </cfloop>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="3" class="text-right">
                        <button type="submit" name="submit" class="btn btn-primary">
                            Save Changes
                        </button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </form>
</cfoutput>
