formatUtil = (function() {
	generatedObject = {
		htmlFormatMoney: function(n, addSpan) {
			var addSpan = typeof addSpan == 'undefined' ? false : addSpan;
			var c = 2,
				dollarClass = n < 0 ? 'dollar-negative' : '',
				i = String(parseInt((n = Math.abs(Number(n) || 0).toFixed(c)))),
				j = (j = i.length) > 3 ? j % 3 : 0,
				result =
					'$' +
					(j ? i.substr(0, j) + ',' : '') +
					i.substr(j).replace(/(\d{3})(?=\d)/g, '1' + ',') +
					(c
						? '.' +
						  Math.abs(n - i)
								.toFixed(c)
								.slice(2)
						: '');
			return addSpan ? '<span class="' + dollarClass + '">' + result + '</span>' : result;
		}
	};

	return generatedObject;
})();
