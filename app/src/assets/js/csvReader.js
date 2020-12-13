CsvReader = function(options) {
	var self = this;
	this.data = [];
	this.headers = [];

	let defaults = {
		buttonSelector: "input[type='file']",
		errorHandler: function(error) {
			alert(error);
		},
		debugLogger: function(message, level) {
			switch (level) {
				case 'warn':
					console.warn(message);
				default:
					console.log(message);
			}
		},
		afterFileRead: function() {
			console.log('Done reading file data');
		}
	};

	var state = Object.assign({}, defaults, options);

	this.initialize = function() {
		state.debugLogger('Initializing CsvReader');
		$(state.buttonSelector).change(readFile);
	};

	this.getData = function() {
		return {
			data: self.data,
			headers: self.headers
		};
	};

	var readFile = function(event) {
		state.debugLogger('Read file event triggered');
		if (event.target.files.length == 0) {
			state.errorHandler('No files');
			return;
		}

		if (event.target.files.length > 1) {
			state.debugLogger('More than file was selected. Only the first file will be loaded.', 'warn');
		}

		var file = event.target.files[0];

		var fReader = new FileReader();
		fReader.onload = function(event) {
			var contents = event.target.result;
			var lines = contents.split('\n');
			for (var i = 0; i < lines.length; i++) {
				var items = lines[i].split(',');
				if (i == 0) {
					for (var j = 0; j < items.length; j++) {
						self.headers.push(items[j]);
					}
				} else if (items.length == self.headers.length) {
					var newRecord = [];
					for (var j = 0; j < items.length; j++) {
						newRecord[j] = items[j];
					}
					self.data.push(newRecord);
				}
			}
			state.afterFileRead();
		};

		fReader.readAsText(file);
	};
};
