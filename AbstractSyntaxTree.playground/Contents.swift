import UIKit

//MARK: - HackerRank Day of Programmer
func dayOfProgrammer(year: Int) -> String {


}

//MARK: - HackerRank Migratory Birds
func migratoryBirds(arr: [Int]) -> Int {
    var dict: [Int: Int] = [:]
    arr.forEach { dict[$0] = (dict[$0] ?? 0) + 1 }
    guard let maxValue = dict.values.max() else {return 0}
    return dict.filter{$0.value == maxValue}.keys.min() ?? 0
}

migratoryBirds(arr: [1,4,4,4,5,3])

//MARK: - HackerRank Divisible Sum Pairs
func divisibleSumPairs(n: Int, k: Int, ar: [Int]) -> Int {
    var count = 0
    for i in (0..<n){
        for j in ((i+1)..<n){
            if (ar[i] + ar[j]) % k == 0 {
                count += 1
            }
        }
    }
    return count
}

divisibleSumPairs(n: 6, k: 3, ar: [1,3,2,6,1,2])


//MARK: - HackerRank Birthday Chocolate
func birthday(s: [Int], d: Int, m: Int) -> Int {
    return s.enumerated().map { arg0 -> Bool in
        let (offset, _) = arg0
        return (offset + m <= s.count) &&
            (offset..<(offset+m)).reduce(0) { $0 + s[$1]} == d
        }.filter{$0}.count
}

birthday(s: [4], d: 4, m: 1)


//MARK: - HackerRank Breaking the Records
func breakingRecords(scores: [Int]) -> [Int] {
    var minPoint = scores[0]
    var maxPoint = scores[0]
    return scores.reduce([0,0]) { (res, score) -> [Int] in
        if score > maxPoint {
            maxPoint = score
            return [res[0]+1, res[1]]
        }
        if score < minPoint{
            minPoint = score
            return [res[0], res[1]+1]
        }
        return [res[0], res[1]]
    }
}

breakingRecords(scores: [3, 4, 21, 36, 10, 28, 35, 5, 24, 42])

//MARK: - HackerRank Between Two Sets
func getTotalX(a: [Int], b: [Int]) -> Int {
    guard let max = a.max(), let min = b.min(), max <= min else {return 0}
    return (max...min).reduce(0) { (res, item) -> Int in
        let lcm = a.reduce(true, { $0 && item % $1 == 0})
        let gcd = b.reduce(true, { $0 && $1 % item == 0})
        return lcm && gcd ? res + 1 : res
    }
}

getTotalX(a: [2,4], b: [16,32,96])


// MARK: - GCD
func gcdIterativeEuklid(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

func gcdRecursiveEuklid(_ m: Int, _ n: Int) -> Int {
    let r: Int = m % n
    return r != 0 ? gcdRecursiveEuklid(n, r) : n
}

func gcdBinaryRecursiveStein(_ m: Int, _ n: Int) -> Int {
    if let easySolution = findEasySolution(m, n) { return easySolution }

    if (m & 1) == 0 {
        // m is even
        if (n & 1) == 1 {
            // and n is odd
            return gcdBinaryRecursiveStein(m >> 1, n)
        } else {
            // both m and n are even
            return gcdBinaryRecursiveStein(m >> 1, n >> 1) << 1
        }
    } else if (n & 1) == 0 {
        // m is odd, n is even
        return gcdBinaryRecursiveStein(m, n >> 1)
    } else if (m > n) {
        // reduce larger argument
        return gcdBinaryRecursiveStein((m - n) >> 1, n)
    } else {
        // reduce larger argument
        return gcdBinaryRecursiveStein((n - m) >> 1, m)
    }
}

func findEasySolution(_ m: Int, _ n: Int) -> Int? {
    return m == n ? m :
        m == 0 ? n :
        n == 0 ? m : nil
}

gcdBinaryRecursiveStein(51357,3819)
gcdIterativeEuklid(51357, 3819)
gcdRecursiveEuklid(51357, 3819)

//MARK: - LCM

enum LCMError: Error{
    case divisionByZero
}

func lcm(_ m: Int, _ n: Int) throws ->  Int {
    guard (m & n) != 0 else {throw LCMError.divisionByZero}
    return m * n / gcdRecursiveEuklid(m, n)
}

lcm(8,10)


//MARK: - HackerRank Kangaroo
func kangaroo(x1: Int, v1: Int, x2: Int, v2: Int) -> String {
    guard x2-x1 != 0 else {return "YES"}
    guard v1 != v2 else {return "NO"}
    let dist = x2-x1
    let vel = v2 - v1
    return dist % vel == 0 && dist * vel < 0 ? "YES" : "NO"
}

kangaroo(x1: 0, v1: 2, x2: 5, v2: 3)
kangaroo(x1: 0, v1: 3, x2: 4, v2: 2)


//MARK: - Abstract Syntax Tree
class Node{
    var operation: String?
    var value: Float?
    var leftChild: Node?
    var rightChild: Node?
    
    init(value: Float?, operation: String?, leftChild: Node?, rightChild: Node?) {
        self.value = value
        self.operation = operation
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
}

let fiveNode = Node(value: 5, operation: nil, leftChild: nil, rightChild: nil)
let twentyFiveNode = Node(value: 25, operation: nil, leftChild: nil, rightChild: nil)
let sixNode = Node(value: 6, operation: nil, leftChild: nil, rightChild: nil)
let multiNode = Node(value: nil, operation: "*", leftChild: twentyFiveNode, rightChild: sixNode)
let sumNode = Node(value: nil, operation: "+", leftChild: multiNode, rightChild: fiveNode)

let rootNode = Node(value: nil, operation: "+", leftChild: multiNode, rightChild: sumNode)

func evaluate(node: Node) -> Float{
    if let value = node.value{
        return value
    }
        
    guard let op = node.operation,
        let left = node.leftChild,
        let right = node.rightChild else {return 0}
    
    switch op {
    case "+": return evaluate(node: left) + evaluate(node: right)
    case "-": return evaluate(node: left) - evaluate(node: right)
    case "*": return evaluate(node: left) * evaluate(node: right)
    case "/":
        guard evaluate(node: right) > 0 else {return 0}
        return evaluate(node: left) / evaluate(node: right)
    default: return 0
    }
}

evaluate(node: rootNode)

//MARK: - Recursion
func sum(_ numbers: [Int]) -> Int{
    guard let first = numbers.first else {return 0}
    return first + sum(Array(numbers.dropFirst()))
}
sum([1,2,3,4,5,6])

func fibonacci(_ i: Int) -> Int{
    guard i>1 else {return 1}
    return fibonacci(i-1) + fibonacci(i-2)
}
fibonacci(10)
