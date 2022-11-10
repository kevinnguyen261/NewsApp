
// Complexity: O(n)

/// Because the Example is Insensitive Compare so isInsensitiveCompare default value is true
func validatePalindrome(string: String, isInsensitiveCompare: Bool = true) -> Bool {
    var stringLength = 0
    var stringArray: [String] = []
    for character in string {
        if isInsensitiveCompare {
            stringArray.append(String(character).lowercased())
        } else {
            stringArray.append(String(character))
        }
        stringLength += 1
    }
    /// Since an Empty string and Single character string reads the same forward and backward, it is a palindrome.
    if stringLength < 2 {
        return true
    }
    var firstIndex = 0
    var lastIndex = stringLength - 1
    /// Stop when firstIndex == lastIndex
    while firstIndex < lastIndex {
        if stringArray[firstIndex] != stringArray[lastIndex] {
            return false
        }
        firstIndex += 1
        lastIndex -= 1
    }
    return true
}

func getResult(string: String) -> String {
    return validatePalindrome(string: string) ? "\(string) is a palindrome" : "\(string) isn’t a palindrome"
}

print(getResult(string: ""))
print(getResult(string: "a"))
print(getResult(string: "aa"))
print(getResult(string: "aKA"))
print(getResult(string: "aka"))
print(getResult(string: "Level"))
print(getResult(string: "Hello"))
