import UIKit


//MARK: - HackerRank Climbing the Leaderboard
func climbingLeaderboard(scores: [Int], alice: [Int]) -> [Int] {
    let uniqueScores = Set(scores).sorted{$0>$1}
    
    return alice.map { score -> Int in
        var hi: Int = 0
        var lo: Int = uniqueScores.count - 1
        var mid: Int = Int(floor(Double(hi + lo) / 2))
        while true{
            if uniqueScores[mid] >= score{
                hi = mid + 1
            }
            else if uniqueScores[mid] <= score{
                lo = mid - 1
            }
            mid = Int(floor(Double(hi + lo) / 2))
            if (lo==hi) {break;}
        }
        
        return mid
    }
}

climbingLeaderboard(scores: [100, 50, 40, 20, 10], alice: [5, 25, 50, 120])

//MARK: - HackerRank Picking Numbers
func pickingNumbers(a: [Int]) -> Int {
    var maxCount = 0
    a.forEach { (item) in
        let downCount = a.filter { (item-1...item).contains($0) }.count
        let upCount = a.filter { (item...item+1).contains($0) }.count
        let maxOfLocal = max(downCount, upCount)
        if maxOfLocal > maxCount{
            print(item)
            maxCount = maxOfLocal}
    }
    return maxCount
}

pickingNumbers(a: [4, 6, 5, 3, 3, 1])

//MARK: - HackerRank Forming a Magic Square
func formingMagicSquare(s: [[Int]]) -> Int {
    let magics = [[[8, 1, 6], [3, 5, 7], [4, 9, 2]],
    [[6, 1, 8], [7, 5, 3], [2, 9, 4]],
    [[4, 9, 2], [3, 5, 7], [8, 1, 6]],
    [[2, 9, 4], [7, 5, 3], [6, 1, 8]],
    [[8, 3, 4], [1, 5, 9], [6, 7, 2]],
    [[4, 3, 8], [9, 5, 1], [2, 7, 6]],
    [[6, 7, 2], [1, 5, 9], [8, 3, 4]],
    [[2, 7, 6], [9, 5, 1], [4, 3, 8]]]
    let row = s.flatMap { $0 }
    let flatMagics = magics.map{ $0.flatMap{$0} }
    return flatMagics.map{ flatItem in
        return zip(row, flatItem).reduce(0) { (res, arg0) -> Int in
            return res + abs(arg0.0 - arg0.1)
        }
    }.min() ?? 0
}

formingMagicSquare(s: [[4,8,2],[4,5,7],[6,1,6]])

//MARK: - HackerRank Cats and a Mouse
func catAndMouse(x: Int, y: Int, z: Int) -> String {
    return abs(x-z) == abs(y-z) ? "Mouse C" :
        abs(x-z) > abs(y-z) ? "Cat B" : "Cat A"
}

catAndMouse(x: 1, y: 2, z: 3)
catAndMouse(x: 1, y: 3, z: 2)

//MARK: - HackerRank Electronics Shop
func getMoneySpent(keyboards: [Int], drives: [Int], b: Int) -> Int {
    guard b != 0 else {return -1}
    var maxCost = 0
    for key in keyboards{
        for drive in drives{
            let cost = drive + key
            if cost > maxCost && cost <= b { maxCost = cost }
        }
    }
    return maxCost != 0 ? maxCost : -1
}

getMoneySpent(keyboards: [3,1], drives: [5,2,8], b: 10)


//MARK: - HackerRank Counting Valleys
func countingValleys(n: Int, s: String) -> Int {
    var sumArray = Array.init(repeating: 0, count: s.count + 1)
    for item in s.enumerated(){
        sumArray[item.offset + 1] = item.element == "U" ? 1 : -1
    }
    (1...sumArray.count-1).forEach { i in
        sumArray[i] = sumArray[i] + sumArray[i-1]
    }
    print(sumArray)
    return sumArray.enumerated().filter { (arg0) -> Bool in
        let (offset, element) = arg0
        guard offset + 1 < sumArray.count else {return false}
        return element == 0 && sumArray[offset+1] == -1
    }.count
}
countingValleys(n: 10, s: "DUDDDUUDUU")

//MARK: - HackerRank Drawing Book
func pageCount(n: Int, p: Int) -> Int {
    min(p/2, n/2 - p/2)
}

pageCount(n: 6, p: 2)


//MARK: - HackerRank Sock Merchant
func sockMerchant(n: Int, ar: [Int]) -> Int {
    var dict: [Int: Int] = [:]
    ar.forEach { dict[$0] = (dict[$0] ?? 0) + 1 }
    return dict.values.map{$0/2}.reduce(0, +)
}

sockMerchant(n: 9, ar: [10, 20, 20, 10, 10,30, 50, 10, 20])

//MARK: - HackerRank Bon Appétit
func bonAppetit(bill: [Int], k: Int, b: Int) -> Void {
    let actualAnnaPay = (bill.reduce(0, +) - bill[k]) / 2
    print( actualAnnaPay == b ? "Bon Appetit" : "\(b - actualAnnaPay)")
}
bonAppetit(bill: [3, 10, 2, 9], k: 1, b: 7)
bonAppetit(bill: [3, 10, 2, 9], k: 1, b: 12)


//MARK: - HackerRank Day of Programmer
func dayOfProgrammer(year: Int) -> String {
    var februaryDayCount = 28
    if year == 1918{
        februaryDayCount = 15
    }else if year > 1918{
        februaryDayCount = year % 400 == 0 || year % 4 == 0 && year % 100 != 0 ? 29 : 28
    }else{
        februaryDayCount = year % 4 == 0 ? 29 : 28
    }
    let monthDays = [31, februaryDayCount, 31, 30, 31, 30, 31, 31]
    let firstEightMonthTotal = monthDays.reduce(0, +)
    let day = 256 - firstEightMonthTotal
    return "\(day).09.\(year)"
}

dayOfProgrammer(year: 1918)
(1700...2700).forEach{print(dayOfProgrammer(year: $0))}


//MARK: - HackerRank Apple and Orange
func countApplesAndOranges(s: Int, t: Int, a: Int, b: Int, apples: [Int], oranges: [Int]) -> Void {
    print(apples.filter { (s...t).contains($0+a)}.count)
    print(oranges.filter{ (s...t).contains($0+b)}.count)
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

//lcm(8,10)


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
