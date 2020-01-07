tableUtil = (function() {
	var createHeaderCells = function(headers) {
		return headers
			.map(function(item) {
				return `<th>${item}</th>`;
			})
			.join('');
	};

	var createBodyCells = function(dataRow, options) {
		if (options.dataType == 'array') {
			return dataRow
				.map(function(cellValue) {
					return `<td>${cellValue}</td>`;
				})
				.join('');
		} else if (Object.keys(options.headerMap).length) {
			return Object.keys(options.headerMap)
				.map(function(key) {
					return `<td>${dataRow[key]}</td>`;
				})
				.join('');
		} else {
			return options.headers
				.map(function(key) {
					return `<td>${dataRow[key]}</td>`;
				})
				.join('');
		}
	};

	var generatedObject = {
		buildHtmlTable: function createTable(argOptions) {
			let defaults = {
				data: [],
				headers: [],
				headerMap: {},
				class: '',
				dataType: 'array' // or object
			};

			var options = Object.assign({}, defaults, argOptions);

			//if a header map was provided, use it to generate the header
			for (var prop in options.headerMap) {
				if (options.headerMap.hasOwnProperty(prop)) {
					options.headers.push(options.headerMap[prop]);
				}
			}

			//if no headers are provided and the data are objects, use them to create the header
			if (options.dataType == 'object' && options.headers == 0 && options.data.length) {
				for (var prop in options.data[0]) {
					if (options.data[0].hasOwnProperty(prop)) {
						options.headers.push(prop);
					}
				}
			}

			var thead = options.headers.length ? `<thead><tr>${createHeaderCells(options.headers)}</tr></thead>` : '';

			var tbody = options.data.length
				? `
				<tbody>
					${options.data
						.map(function(row) {
							return `<tr>${createBodyCells(row, options)}</tr>`;
						})
						.join('')}
				</tbody>`
				: '';
			return $(`
				<table class="${options.class}"> 
					${thead + tbody} 
				</table>`);
		}
	};

	return generatedObject;
})();
