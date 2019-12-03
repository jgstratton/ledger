formUtil = (function() {
	generatedObject = {
		objectifyForm: function($form) {
			var formArray = $form.serializeArray();
			var formDataValueArrays = {};
			for (var i = 0; i < formArray.length; i++) {
				if (!(formArray[i]['name'] in formDataValueArrays)) {
					formDataValueArrays[formArray[i]['name']] = [];
				}
				formDataValueArrays[formArray[i]['name']].push(formArray[i]['value']);
			}

			var formData = {};
			for (var property in formDataValueArrays) {
				formData[property] = formDataValueArrays[property].join();
			}
			return formData;
		},

		renameInputs: function(formData, inputMap) {
			for (var originalProperty in inputMap) {
				formData[inputMap[originalProperty]] = formData[originalProperty];
				delete formData[originalProperty];
			}
			return;
		}
	};

	return generatedObject;
})();
