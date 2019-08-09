chartUtil = (function() {
    function getColorValue(offset) {
        var randVal = Math.floor(Math.random() * 255 - offset);
        randVal += offset;
        return randVal.toString();
    }

    generatedObject = {
        getRandomColor: function() {
            var rgbValues = [getColorValue(0), getColorValue(125), getColorValue(200)];
            rgbValues.sort(() => Math.random() - 0.5);
            return 'rgb(' + rgbValues[0] + ', ' + rgbValues[1] + ', ' + rgbValues[2] + ')';
        }
    };

    return generatedObject;
})();
