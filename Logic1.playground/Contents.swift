
// Complexity: O(n)
func findMiddleIndex(array: [Int]) -> Int? {
    var arrayLength = 0
    /// Array of sum Left, start with 0
    var sumLeftArray: [Int] = [0]
    for (index, element) in array.enumerated() {
        sumLeftArray.append(element + sumLeftArray[index])
        arrayLength += 1
    }
    /// If Array have 1 element => Middle Index is 0
    if arrayLength == 1 {
        return 0
    }
    /// If Array have 0 or 2 element => No middle index
    guard arrayLength > 2, let totalValue = sumLeftArray.popLast() else {
        return nil
    }
    for (index, sumLeftElement) in sumLeftArray.enumerated() {
        /// sumLeftElement == sumRightElement <=> totalValue - leftElement  == 2 * sumLeftElement
        if totalValue - array[index] == sumLeftElement * 2 {
            return index
        }
    }
    return nil
}

func getResult(array: [Int]) -> String {
    if let index = findMiddleIndex(array: array) {
        return "middle index is \(index)"
    }
    return "index not found"
}

print(getResult(array: [10]))
print(getResult(array: [1, 3]))
print(getResult(array: [3, 3, 3]))
print(getResult(array: [3, 0, 0, 3]))
print(getResult(array: [1, 3, 5, 7, 9]))
print(getResult(array: [1, -3, -5, 7, -7]))
print(getResult(array: [4, 6, 8, 1, 5, 10, 1, 8]))
print(getResult(array: [3, 5, 6]))
