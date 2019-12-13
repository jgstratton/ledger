component {

	//combinations with an index value as the key.
	combinations = {};

	//a lookup of where the items is stored in the combinations struct
	combinationLookup = {};
	
	/**
	 * Initialize a new combinations component with an array of items and the numer of items that should be in each combination.
	 * If the items are objects, then a hashing function must be provided to generate an id for each object.
	 */ 
	public component function init(required array items, required numeric size, hashFunction) {
		var hasHasFunction = arguments.keyExists('hashFunction');
		if (hasHasFunction) {
			variables.hashFunction = arguments.hashFunction;
		}
		validateItemTypes(items);
		items = removeDuplicates(items);

		var combinationIndexes = buildCombinationIndexes(items.len(), size);
		for (var i = 1; i<= combinationIndexes.len(); i++) {
			combinations[i] = combinationIndexes[i].map(function(itemPosition){
				addToLookup(items[itemPosition], i);
				return items[itemPosition];
			});
		}		
		return this;
	}

	public array function getCombinations() {
		var combinationsArray = [];
		for (var i in listToArray(structKeyList(combinations))) {
			combinationsArray.append(combinations[i]);
		}
		return combinationsArray;
		
	}

	public void function removeItem(required any item) {
		validateItemTypes([item]);
		var hashValue = isSimpleValue(item) ? item : hashfunction(item);
		if (combinationLookup.keyExists(hashValue)) {
			for (var i in combinationLookup[hashValue]) {
				structDelete(combinations,i);
			}
			structDelete(combinationLookup, hashValue);
		}
	}

	private array function buildCombinationIndexes(numeric length, numeric size) {
		var seed = [];
		for (var i = 1; i <= size; i++) {
			seed.append(i);
		}
		var results = [seed];

		while (results.last().first() < (length - (size - 1))) {
			var nextCombination = getNextCombination(length, size, results.last())
			results.append(nextCombination);
		}
		return results;
	}

	private array function getNextCombination(numeric length, numeric size, array lastCombination) {
		var newCombination = duplicate(lastCombination);
		//create the next combination
		for (var i = size; i >= 1; i--) {
			if(newCombination[i] < (length - (size - i))) {
				newCombination[i] += 1;
				for (var k = i + 1; k <= size; k++) {
					newCombination[k] = newCombination[k-1] + 1;
				}
				break;
			}
		}

		return newCombination;
	}

	private void function addToLookup(required any item, required numeric index) {
		var hashValue = isSimpleValue(item) ? item : hashfunction(item);

		if (!combinationLookup.keyExists(hashValue)) {
			combinationLookup[hashValue] = [];
		}

		combinationLookup[hashValue].append(index);
	}

	private void function validateItemTypes(required array items){
		for (var item in items) {
			if (isBoolean(item) &&!isNumeric(item)) {
				throw(type="InvalidItemType", message="Boolean values can be used in combinations");
			}
			if (!isSimpleValue(item) && !variables.keyExists('hashFunction')) {
				throw(type="MissingHashFunction", message="A hash function must be provided for any non-simple array elements");
			}
		}
	}

	private array function removeDuplicates(required array items) {
		var results = [];
		var filter = {};
		for (var item in items) {
			var hashValue = isSimpleValue(item) ? item : hashfunction(item);
			if (!filter.keyExists(hashValue)) {
				results.append(item);
				filter[hashValue] = 1;
			}
		}
		return results;
	}
}