tableUtil = (function() {
	generatedObject = {
		buildHtmlTable: function createTable(argOptions) {
			let defaults = {
				data: [],
				headers: [],
				class: ''
			};

			var options = Object.assign({}, defaults, argOptions);

			var thead = options.headers.length
				? `
					<thead>
						<tr>
							${options.headers
								.map(function(item) {
									return `<th>${item}</th>`;
								})
								.join('')}
						</tr>
					</thead>`
				: '';

			var tbody = options.data.length
				? `
				<tbody>
					${options.data
						.map(function(row) {
							return `
							<tr>
								${row
									.map(function(cellValue) {
										return `<td>${cellValue}</td>`;
									})
									.join('')}
							</tr>`;
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
