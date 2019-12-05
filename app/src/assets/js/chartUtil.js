chartUtil = (function() {
	function getColorValue(offset) {
		var randVal = Math.floor(Math.random() * 200 - offset);
		randVal += offset;
		return randVal.toString();
	}

	generatedObject = {
		getRandomColor: function() {
			var rgbValues = [getColorValue(0), getColorValue(125), getColorValue(175)];
			rgbValues.sort(() => Math.random() - 0.5);
			return 'rgb(' + rgbValues[0] + ', ' + rgbValues[1] + ', ' + rgbValues[2] + ')';
		},
		resizeChartContainer: function($chartContainer, customSettings) {
			const defaultSettings = {
				aspectRation: [1, 1],
				maxWidth: 1000,
				maxHeight: 1000,
				minWidth: 100,
				minHeight: 100
			};

			const settings = { ...defaultSettings, ...customSettings };

			const calcWidth = $chartContainer.parent().width();
			const calcHeight = calcWidth * (settings.aspectRation[1] / settings.aspectRation[0]);

			const finalWidth =
				calcWidth > settings.maxWidth
					? settings.maxWidth
					: calcWidth < settings.minWidth
					? settings.minWidth
					: calcWidth;
			const finalHeight =
				calcHeight > settings.maxHeight
					? settings.maxHeight
					: calcHeight < settings.minHeight
					? settings.minHeight
					: calcHeight;

			$chartContainer.width(finalWidth);
			$chartContainer.height(finalHeight);
		}
	};

	return generatedObject;
})();
