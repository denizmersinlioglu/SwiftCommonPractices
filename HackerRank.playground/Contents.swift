import UIKit

//MARK: - HackerRank ACM ICPC Team

//MARK: - HackerRank Queen's Attack II
func queensAttack(n: Int, k: Int, r_q: Int, c_q: Int, obstacles: [[Int]]) -> Int {
        
    enum QueenMove {
        case up, down, right, left, upLeft, upRight, downLeft, downRight
        static var all: [QueenMove] = [.up, .down, .right, .left,
                                       .upLeft, .upRight, .downLeft, .downRight]
    }
    
    var dict: [QueenMove: Int] = [ .up: n - r_q, .down: r_q-1,
                                   .right: n - c_q, .left: c_q-1,
                                   .upLeft: min(c_q-1, n-r_q), .upRight: min(n-r_q, n-c_q),
                                   .downLeft: min(r_q-1, c_q-1), .downRight: min(r_q-1, n-c_q) ]
    for i in (0..<k){
        let r = obstacles[i][0]
        let c = obstacles[i][1]
        
        if (c == c_q && r>r_q), let prev = dict[.up]{
            let d = r-r_q-1
            if d<prev { dict[.up] = d }
            
        }else if (c == c_q && r<r_q), let prev = dict[.down]{
            let d = r_q-r-1
            if d<prev { dict[.down] = d }
            
        }else if (r == r_q && c < c_q), let prev = dict[.left]{
            let d = c_q-c-1
            if d<prev { dict[.left] = d }
            
        }else if (r == r_q && c > c_q), let prev = dict[.right]{
            let d = c-c_q-1
            if d<prev { dict[.right] = d }
            
        }else if ((r-r_q)==(c-c_q) && r>r_q && c>c_q), let prev = dict[.upRight]{
            let d = r-r_q-1
            if d<prev { dict[.upRight] = d }
            
        }else if (r>r_q && c<c_q && ((c_q-c)==(r-r_q)) ), let prev = dict[.upLeft]{
            let d = r-r_q-1
            if d<prev { dict[.upLeft] = d }
            
        }else if (c>c_q && r<r_q && ((r_q-r)==(c-c_q)) ), let prev = dict[.downRight]{
            let d = r_q-r-1
            if d<prev { dict[.downRight] = d }
            
        }else if (r_q>r && c_q>c && ((r_q-r)==(c_q-c)) ), let prev = dict[.downLeft]{
            let d = r_q-r-1
            if d<prev { dict[.downLeft] = d }
        }
    }
    return QueenMove.all.reduce(0) { $0 + (dict[$1] ?? 0)}
}

queensAttack(n: 5, k: 3, r_q: 4, c_q: 3, obstacles: [[5,5],[4,2], [2,3]])

func queensAttack3(n: Int, k: Int, r_q: Int, c_q: Int, obstacles: [[Int]]) -> Int {
    typealias Pos = (Int,Int)
    
    let obs = obstacles.filter { (obs) -> Bool in
        let rel: Pos = (obs[0] - r_q, obs[1] - c_q)
        return rel.0 == 0 || rel.1 == 0 || (abs(rel.0) == abs(rel.1))
    }
    
    enum QueenMove {
        case up, down, right, left, upLeft, upRight, downLeft, downRight
        static var all: [QueenMove] = [.up, .down, .right, .left,
                                       .upLeft, .upRight, .downLeft, .downRight]
    }
    
    let moveDict: [QueenMove: Pos] =
        [.up: (1,0), .down: (-1,0), .right: (0,1), .left: (0,-1),
        .upLeft: (1,-1), .upRight: (1,1), .downLeft: (-1,-1), .downRight: (-1,1)]
    
    func moveQueen(from pos: Pos, with move: QueenMove) -> Pos{
        let move = moveDict[move] ?? (0,0)
        return (pos.0 + move.0, pos.1 + move.1)
    }
    
    func isObstacle(pos: Pos) -> Bool{
        return obs.firstIndex { $0[0] == pos.0 && $0[1] == pos.1 } != nil
    }
    
    func inBounds(pos: Pos) -> Bool{
        return pos.0 <= n && pos.0 > 0 && pos.1 <= n && pos.1 > 0
    }
    
    func calculateMove(for move: QueenMove) -> Int{
        var count = 0
        var currentPosition = (r_q, c_q)
        while true{
            let nextPosition = moveQueen(from: currentPosition, with: move)
            print("current Pos: \(currentPosition)")
            print("next Pos: \(nextPosition)")
            currentPosition = nextPosition
            if isObstacle(pos: nextPosition) || !inBounds(pos: nextPosition){
                break
            }else{
                count += 1
            }
        }
        print("End to move for: \(move), count \(count)\n")
        return count
    }
    
    return QueenMove.all.reduce(0) { $0 + calculateMove(for: $1) }
}

func queensAttack2(n: Int, k: Int, r_q: Int, c_q: Int, obstacles: [[Int]]) -> Int {
    typealias Container = [(Int,Int)]

    func inBounds(c: (Int,Int)) -> Bool{
        return c.0 > 0 && c.0<=n && c.1 > 0 && c.1<=n
    }
    
    func distanceTo(obstacle: [Int]) -> Int{
        let dis = abs(obstacle.reduce(0, +) - r_q - c_q) - 1
        print("Distance to obstacle: \(obstacle) is \(dis)")
        return dis
    }
    
    func diagDistanceTo(obstacle: [Int]) -> Int{
        guard obstacle[0] != r_q else {return 0}
        let dis = abs(obstacle[0] - r_q) - 1
        print("Distance to diagonal obstacle: \(obstacle) is \(dis)")
        return dis
    }
    
    var diag0 = Container()
    var diag1 = Container()
    for i in (-n...n){
        diag0.append((r_q+i, c_q+i))
        diag1.append((r_q-i, c_q+i))
    }
    diag0 = diag0.filter{ inBounds(c: $0) }
    diag1 = diag1.filter{ inBounds(c: $0) }
    
    print("diag0 \(diag0)")
    print("diag1 \(diag1)")
    
    let leftObstacle = obstacles
        .filter{$0[0] == r_q && $0[1] < c_q}
        .min { abs($0[1] - c_q) < abs($1[1]-c_q) } ?? [r_q, 0]
    let rightObstacle = obstacles
        .filter{$0[0] == r_q && $0[1] > c_q}
        .min { abs($0[1] - c_q) < abs($1[1]-c_q) } ?? [r_q, n+1]
    let upObstacle = obstacles
        .filter{$0[1] == c_q && $0[0] > r_q}
        .min { abs($0[0] - r_q) < abs($1[0]-r_q) } ?? [n+1, c_q]
    let downObstacle = obstacles
        .filter{$0[1] == c_q && $0[0] < r_q}
        .min { abs($0[0] - r_q) < abs($1[0]-r_q) } ?? [0, c_q]
    
    let endPoints = [leftObstacle, rightObstacle, upObstacle, downObstacle]
    
    let diagUpLeft = obstacles
        .filter { ($0[1] - c_q == $0[0] - r_q) && $0[0] > r_q && $0[0] < c_q }
        .min { abs($0[0] - r_q) + abs($0[1] - c_q) < abs($1[0] - r_q) + abs($1[1] - c_q) } ?? [diag1.first!.0 + 1 , diag1.first!.1 - 1 ]
    let diagDownRight = obstacles
        .filter { ($0[1] - c_q == $0[0] - r_q) && $0[0] < r_q && $0[0] > c_q }
        .min { abs($0[0] - r_q) + abs($0[1] - c_q) < abs($1[0] - r_q) + abs($1[1] - c_q) } ?? [diag1.last!.0 - 1 , diag1.last!.1 + 1]
    
    let diagUpRight = obstacles
        .filter { ($0[1] - c_q == $0[0] - r_q) && $0[0] > r_q && $0[0] > c_q }
        .min { abs($0[0] - r_q) + abs($0[1] - c_q) < abs($1[0] - r_q) + abs($1[1] - c_q) } ?? [diag0.last!.0 + 1, diag0.last!.1 + 1]
    let diagDownLeft = obstacles
        .filter { ($0[1] - c_q == $0[0] - r_q) && $0[0] < r_q && $0[0] < c_q }
        .min { abs($0[0] - r_q) + abs($0[1] - c_q) < abs($1[0] - r_q) + abs($1[1] - c_q) } ?? [diag0.first!.0 - 1 , diag0.first!.1 - 1]
    
    
    let diagEndPoints = [diagUpLeft, diagUpRight, diagDownLeft, diagDownRight]
    
    let sum = endPoints.reduce(0) { (res, item) -> Int in
        return res + distanceTo(obstacle: item)
    }
    
    let sumDiag = diagEndPoints.reduce(0) { (res, item) -> Int in
        return res + diagDistanceTo(obstacle: item)
    }
    return sum + sumDiag

}



//MARK: - HackerRank Equalize the Array
func equalizeArray(arr: [Int]) -> Int {
    var dict: [Int: Int] = [:]
    arr.forEach { (item) in
        if let count = dict[item] {
            dict[item] = count + 1
        }else{
            dict[item] = 1
        }
    }
    let maxCount = dict.max { (first, second) -> Bool in
        return second.1 > first.1
    }?.value ?? 0
    return arr.count - maxCount
}

equalizeArray(arr: [3, 3, 2, 1, 3])

//MARK: - HackerRank Cut the sticks
func cutTheSticks(arr: [Int]) -> [Int] {
    var notZeroCount = arr.count
    var sticksCut: [Int] = [arr.count]
    var temp = arr
    
    while notZeroCount > 0{
        let minVal = temp.filter{$0>0}.min()
        guard let min = minVal else {break}
        temp = temp.map{ item in
            if item > 0 {
                return item - min
            }else{
                return 0
            }
        }
        notZeroCount = temp.filter{$0>0}.count
        if notZeroCount != 0{
            sticksCut.append(notZeroCount)
        }
    }
    return sticksCut
}

cutTheSticks(arr: [1, 2, 3, 4, 3, 3, 2, 1])

//MARK: - HackerRank Library Fine
func libraryFine(d1: Int, m1: Int, y1: Int, d2: Int, m2: Int, y2: Int) -> Int {
    let dueDate = d2 + m2 * 30 + y2 * 365
    let returnDate = d1 + m1 * 30 + y1 * 365
    guard returnDate > dueDate else {return 0}
    if y1 > y2{
        return (y1-y2)*10000
    }else if m1 > m2{
        return (m1-m2)*500
    }else if d1 > d2{
        return(d1-d2)*15
    }else{
        return 0
    }
}
libraryFine(d1: 9, m1: 6, y1: 2015, d2: 6, m2: 6, y2: 2015)

//MARK: - HackerRank Circular Array Rotation
func circularArrayRotation(a: [Int], k: Int, queries: [Int]) -> [Int] {
    return queries.map { item in
        let index = (item-k) % a.count
        let positiveIndex = index < 0 ? index + a.count : index
        return a[positiveIndex]
    }
}
let b = -24 % 5
let c = b < 0 ? b + 5 : b

//MARK: - HackerRank Jumping on the Clouds
func jumpingOnClouds(c: [Int]) -> Int {
    var index = 0
    var jumpCount = 0
    while index < c.count - 1{
        if index + 2 < c.count{
            index = index + (c[index+2] == 0 ? 2 : 1)
        }else{
            index = index + 1
        }
        jumpCount += 1
        print("jumpCount \(jumpCount), index \(index)")
    }
    return jumpCount
}

//MARK: - HackerRank Save the Prisoner!
func saveThePrisoner(n: Int, m: Int, s: Int) -> Int {
    let a = s+m-1
    if (a>n){
        return a%n == 0 ? n : a%n
    }
    return a
}


//MARK: - HackerRank Viral Advertising
func viralAdvertising(n: Int) -> Int {
    var shared = 5
    var liked = 0
    var sum = 0
    for _ in (1...n){
        liked = shared/2
        sum += liked
        shared = liked * 3
        print(sum)
    }
    return sum
}

viralAdvertising(n: 3)

//MARK: - HackerRank Beautiful Days at the Movies
func beautifulDays(i: Int, j: Int, k: Int) -> Int {
    func reverseNumber(_ n: Int) -> Int{
        var temp = n
        var reverse = 0
        while temp > 0{
            reverse = reverse * 10
            reverse = reverse + temp % 10
            temp = temp/10
        }
        return reverse
    }
    return (i...j).filter{ abs($0 - reverseNumber($0)) % k == 0 }.count
}

//MARK: - HackerRank Angry Professor
func angryProfessor(k: Int, a: [Int]) -> String {
    return a.filter{$0 <= 0}.count >= k ? "NO" : "YES"
}


//MARK: - HackerRank Utopian Tree
func utopianTree(n: Int) -> Int {
    if n == 0 {return 1}
    var currentHeight = 1
    for i in (1...n){
        if i % 2 != 0{
            currentHeight = currentHeight * 2
        }else{
            currentHeight = currentHeight + 1
        }
    }
    return currentHeight
}


//MARK: - HackerRank Designer PDF Viewer
func designerPdfViewer(h: [Int], word: String) -> Int {
    let mapStrings = "abcdefghijklmnopqrstuvwxyz"
    var heightDic: [Character: Int] = [:]
    mapStrings.enumerated().forEach { (arg0) in
        let (offset, element) = arg0
        heightDic[element] = h[offset]
    }
    let maxHeight = word.map { char in
        return heightDic[char] ?? 0
    }.max() ?? 0
    return maxHeight * word.count
}

//MARK: - HackerRank The Hurdle Race
func hurdleRace(k: Int, height: [Int]) -> Int {
    let maxHeight = height.max() ?? 0
    return k >= maxHeight ? 0 : abs(maxHeight - k)
}


jumpingOnClouds(c: [0, 0, 0, 1, 0, 0])

//MARK: - HackerRank Repeated String
func repeatedString(s: String, n: Int) -> Int {
    let count = s.filter{ String($0) == "a"}.count
    let multipleTotal = (n / s.count) * count
    let rem = s.prefix(n % s.count).filter{ String($0) == "a"}.count
    return multipleTotal + rem
}

repeatedString(s: "a", n: 1000000000000)

//MARK: - HackerRank NonDivisibleSubset
func nonDivisibleSubset(k: Int, s: [Int]) -> Int {
    let modArray = s.map{ $0 % k }
    return (0...k/2).map { (item) -> Int in
        if item == 0 || (k%2 == 0 && item == k/2){
            return modArray.filter{$0 == item}.isEmpty ? 0 : 1
        }
        let modCount = modArray.filter{$0 == item}.count
        let reverseModCount = modArray.filter{$0 == k - item}.count
        return max(modCount, reverseModCount)
    }.reduce(0, +)
}

nonDivisibleSubset(k: 4, s: [19,10,12,10,24,25,22])

//MARK: - HackerRank Sherlock and Squares
func squares(a: Int, b: Int) -> Int {
    let aSqrt = floor(sqrt(Double(a)-0.5))
    let bSqrt = floor(sqrt(Double(b)+0.5))
    return Int(bSqrt - aSqrt)
}

squares(a: 17, b: 24)

//MARK: - HackerRank Append and Delete
func appendAndDelete(s: String, t: String, k: Int) -> String {
    if s.count + t.count < k {return "Yes"}
    var baseCount = 0
    for (first, second) in zip(s, t){
        if first == second{ baseCount += 1 }
        else{ break }
    }
    let operationCount = s.count + t.count - 2*baseCount
    guard k-operationCount >= 0 else {return "No"}
    return (k - operationCount) % 2 == 0 ? "Yes" : "No"
}

appendAndDelete(s: "qwerasdf", t: "qwerbsdf", k: 6)

//MARK: - HackerRank Extra Long Factorials
func extraLongFactorials(n: Int) -> Void {
    guard n > 2 else {return print(1)}
    func carryAll(_ arr: [Int]) -> [Int] {
        print("Start Carry with: \(arr)")
        var result = [Int]()

        var carry = 0
        for val in arr.reversed() {
            let total = val + carry
            let digit = total % 10
            carry = total / 10
            result.append(digit)
        }

        while carry > 0 {
            let digit = carry % 10
            carry = carry / 10
            result.append(digit)
        }
        let out = Array(result.reversed())
        print("End Carry with: \(out)")
        print("")
        return result.reversed()
    }
    
    var result = [1]
    for i in 2...n {
        result = result.map { $0 * i }
        result = carryAll(result)
    }

    print(result.map(String.init).joined())

}

extraLongFactorials(n: 21)


//MARK: - HackerRank Find Digits
func findDigits(n: Int) -> Int {
    let stringDigits = "\(n)"
    return stringDigits.filter { (char) -> Bool in
        guard let intChar = Int(String(char)) else {return false}
        guard intChar != 0 else {return false}
        return n % intChar == 0
    }.count
}

findDigits(n: 1012)

//MARK: - HackerRank Jumping on Clouds
func jumpingOnClouds(c: [Int], k: Int) -> Int {
    var e = 100
    var index = 0
    repeat{
        index = ( index + k ) % c.count
        e = c[index] == 1 ? (e - 3) : (e - 1)
    } while (index != 0 && e > 0)
    return e
}

jumpingOnClouds(c: [0, 0, 1, 0, 0, 1, 1, 0], k: 2)

//MARK: - HackerRank Permutation Equation
func permutationEquation(p: [Int]) -> [Int] {
    var inverseP = Array(repeating: 0, count: p.count)
    p.enumerated().forEach { arg0  in
        let (index, element) = arg0
        inverseP[element-1] = index
    }
    return (0..<p.count).map{inverseP[inverseP[$0]] + 1}
}

permutationEquation(p: [4, 3, 5, 1, 2])

//MARK: - HackerRank Climbing the Leaderboard
func climbingLeaderboard(scores: [Int], alice: [Int]) -> [Int] {
    var uniqueScores = [Int]()
    uniqueScores.append(scores[0])
    
    for i in (1..<scores.count){
        if scores[i] != scores[i-1]{
             uniqueScores.append(scores[i])
        }
    }
    
    func binarySearch(in numbers: [Int], for value: Int) -> Int{
        var left = 0
        var right = numbers.count - 1
        var middle = 0
        
        while left <= right {

            middle = Int(floor(Double(left + right) / 2.0))

            if numbers[middle] > value {
                left = middle + 1
            } else if numbers[middle] < value {
                right = middle - 1
            } else {
                return middle
            }
        }
        
        if numbers[middle] < value {
            middle = middle - 1
        }
        return middle + 1
    }
    
    return alice.map { score -> Int in
        return binarySearch(in: uniqueScores, for: score) + 1
    }
}

climbingLeaderboard(scores: [100, 90, 90, 80, 75, 60], alice: [50, 65, 77, 90, 102])

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
