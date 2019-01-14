<cfoutput>
    <div class="row">
        <label class="col-3 col-form-label">Type:</label>
        <div class="col-9">
            <select name="schedularTypeId" class="form-control form-control-sm" data-type-control>
                <cfloop array="#rc.schedularTypes#" item="local.schedularType">
                    <option value="#local.schedularType.getId()#" data-controls="#local.schedularType.getAllowedParameters()#" #selectIf( local.schedular.getSchedularType().getId() eq local.schedularType.getId() )#>
                        #local.schedularType.getName()#
                    </option>
                </cfloop>
            </select>
        </div>
    </div>

    <div data-controls>
        <div class="row d-none">
            <label class="col-3 col-form-label">Months:</label>
            <div class="col-9">
                <select name="monthsOfYear" multiple="multiple" class="form-control form-control-sm form-control-ms" data-multiselect>
                    <cfloop from="1" to="12" index="local.i">
                        <option value="#local.i#" #selectIf( listFindNocase(local.schedular.getMonthsOfYear(), local.i) )# >
                            #monthAsString(i)#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>
        <div class="row d-none">
            <label class="col-3 col-form-label">Days of month:</label>
            <div class="col-9">
                <select name="daysOfMonth" multiple="multiple" class="form-control form-control-sm form-control-ms" data-multiselect>
                    <cfloop from="1" to="31" index="local.i">
                        <option value="#local.i#" #selectIf( listFindNocase(local.schedular.getDaysOfMonth(), local.i) )#>
                            #local.i#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>
        <div class="row d-none">
            <label class="col-3 col-form-label">Start Date:</label>
            <div class="col-9">
                <input type="text" name="startDate" class="form-control form-control-sm" value="#local.schedular.getStartDate()#" data-datepicker readonly>
            </div>
        </div>
        <div class="row d-none">
            <label class="col-3 col-form-label">Interval:</label>
            <div class="col-9">
                <select name="dayInterval" class="form-control form-control-sm">
                    <cfloop from="1" to="28" index="local.i">
                        <option value="#local.i#" #selectIf( listFindNocase(local.schedular.getDayInterval(), local.i) )#>
                            #local.i#
                        </option>
                    </cfloop>
                </select>
            </div>
        </div>
    </div>
    <div class="row">
        <label class="col-3 col-form-label">Active:</label>
        <div class="col-9">
            <input type="checkbox" name="schedularStatus" value="1" #checkif(local.schedular.getStatus())# >
        </div>
    </div>

    <script>
        viewScripts.add( function(){
            var $modalDiv = $("##" + "#local.templateId#"),
                $controlRows = $modalDiv.find("[data-controls] > .row"),
                $controls = $controlRows.find("select, input"),
                $datePicker = $modalDiv.find('[data-datepicker]'),
                $multiSelect = $modalDiv.find('[data-multiselect]'),
                $typeControl = $modalDiv.find("[data-type-control]"),

                showControls = function(){
                    var options = $typeControl.find('option:selected').data('controls').split(",");
                    $controlRows.addClass('d-none');
                    for (var i = 0; i < options.length; i++) {
                        $controls.filter('[name="' + options[i] + '"]').closest('.row').removeClass('d-none');
                    }
                };

            $datePicker.datepicker();
            $multiSelect.multipleSelect();
            $typeControl.change(function(){
                showControls()
            });

            showControls();

            console.log($datePicker.length);
        });
    </script>
</cfoutput>