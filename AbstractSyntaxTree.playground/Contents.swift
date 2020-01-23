import UIKit


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
