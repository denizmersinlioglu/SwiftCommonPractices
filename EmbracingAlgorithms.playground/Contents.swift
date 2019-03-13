
import Foundation
///  🚲 Shape object for test the algorithms.
struct Shape{
    var isSelected: Bool{
        return Int.random(in: 0...10) < 10
    }
}

struct Canvas{
    var shapes = [Shape()]
}

// Remove from backwards will prevent array length and index bugs.
extension Array where Element == Shape{
    
    /**
     Removes all elements selected in the array.
     
     - For loop create n complexity and remove(at: )
     - Shifting all elements to the right after i.
     - Total complexity is O(n2) and its not scaled well for large memory operations.
     ```
     for i in (0..<self.count).reversed(){
        if self[i].isSelected{
            shapes.remove(at: i)
        }
     }
     ```
     - Complexity: O(n2) where n is the number of elements.
     - Precondition: `Element` must be a Shape object.
     */
    mutating func deleteSelection(){
        for i in (0..<count).reversed(){
            if self[i].isSelected{
                self.remove(at: i)
            }
        }
    }
    
    /**
     Removes all elements selected in the array.
     
     - Looping and removing all selected elements in O(n) complexity.
     
     ```
     self.removeAll { $0.isSelected }
     ```
     - Complexity: O(n) where n is the number of elements.
     - Precondition: `Element` must be a Shape object.
     */
    mutating func deleteSelectionElegant(){
        self.removeAll { $0.isSelected }
        // Total complexity is O(n) -> It solves the scalability problem.
    }
    
    /**
     Bring to Front all elements selected in the array.
     
     - For loop create n complexity and remove(at: ) & insert(_ ,at: ) create 2n complexity
     - Total complexity is O(n2) and its not scaled well for large memory operations.
     ```
     while i < shapes.count{
        if shapes[i].isSelected{
            let selected = shapes.remove(at: i)
            shapes.insert(selected, at: j)
            j += 1
        }
        i += 1
     }
     ```
     - Complexity: O(n2) where n is the number of elements.
     - Precondition: `Element` must be a Shape object.
     */
    mutating func bringToFront(elementsSatisfying predicate: (Element)->Bool){
        var i = 0, j = 0
        while i < count{
            if predicate(self[i]){
                let selected = self.remove(at: i)
                self.insert(selected, at: j)
                j += 1
            }
            i += 1
        }
    }
    
    
    /**
     Bring to Front all elements selected in the array.
     
     - stablePartition works in O(nlogn)
     - logn can assumed as constant in big values of n. So O(nlogn) can be assumed as O(n)
     - Total complexity is O(n2) and its not scaled well for large memory operations.
     ```
        shapes.stablePartition(isSuffixElement: !$0.isSelected)
     ```
     - Complexity: O(nlogn) where n is the number of elements.
     
     */
    mutating func bringToFrontElegant(){
        //shapes.stablePartition(isSuffixElement: !$0.isSelected) -> Keep the order of moved back objects.
    }
    
    
    /**
     Bring Forward all elements to front of selected element in the array.
     
     - stablePartition works in O(nlogn)
     - logn can assumed as constant in big values of n. So O(nlogn) can be assumed as O(n)
     - Total complexity is O(n2) and its not scaled well for large memory operations.
     ```
     if let i = shapes.firstIndex(where: {$0.isSelected}){
        if i == 0 {return}
            let predecessor = i-1
            shapes[predecessor...].stablePartition(isSuffixElement: {$0.isSelected})
            // Means the same as shapes[predecessor..<endIndex]
     }
     ```
     - Complexity: O(nlogn) where n is the number of elements.
     
     */
    mutating func bringForward(elementsSatisfying predicate: (Element)->Bool){
        if let i = self.firstIndex(where: predicate){
            if i == 0 {return}
            // let predecessor = i-1
            // shapes[predecessor...].stablePartition(isSuffixElement: {$0.isSelected})
            // Means the same as shapes[predecessor..<endIndex]
        }
    }
    
    
    /**
     A Test function for documentation
     
     - Taking arguments and returning one of the first two parameters.
     
     - Parameters:
     - arg1: Dummy String
     - arg2: Dummy String
     - arg3: A shape object
     
     - Returns: A beatutiful dummy strings that one of the arguments
     
     ```
     return arg3.isSelected ? arg1 : arg2
     ```
     - Complexity: O(1)
     - Precondition: `arg3` must be a Shape object.
     */
    
    func foo(arg1: String, arg2: String, arg3: Shape) -> String{
        return arg3.isSelected ? arg1 : arg2
    }
    
}

extension MutableCollection where Self: RangeReplaceableCollection{
    /**
     Removes all elements satisfying "shouldRemove"
     - Complexity: O(n) where n is the number of elements.
     */
    mutating func removeAllCopy(where shouldRemove: (Element)->Bool){
        // let suffixStart = halfStablePartition(isSuffixElement: shouldRemove)
        // if shouldRemove -> move the elements to end of array. O(n)
        // halfStable -> not moved elements are stable (not change in order)
        //            -> moved elements order is changed.
        // removeSubrange(suffixStart...) -> Remove the moved elements at the end. Order doesn't matters.
        // suffixStart... -> Range to the end of the collection
        
    }
    
    /**
     Moves all elements satisfying 'isSuffixElement' into a suffix of the collection.
     - Returns: The start position of the resulting suffix.
     - Complexity: O(n) where n is the number of elements.
     
     */
    mutating func halfStablePartitionCopy(isSuffixElement: (Element)->Bool) -> Index{
        guard var i = firstIndex(where: isSuffixElement) else {return endIndex}
        var j = index(after: i)
        while j != index(after: i){
            if !isSuffixElement(self[j]){
                swapAt(i, j)
                formIndex(after: &i)
            }
            formIndex(after: &j)
        }
        return i
    }
    
    mutating func stablePartitionCopy(count n: Int, isSuffixElement: (Element)-> Bool) -> Index{
        if n == 0 {return startIndex}
        if n == 1 {return isSuffixElement(self[startIndex]) ? startIndex : endIndex}
        let h = n/2, i = index(startIndex, offsetBy:h)
        let j = self[..<i].stablePartitionCopy(count: h, isSuffixElement: isSuffixElement)
        let k = self[i...].stablePartitionCopy(count: n-h, isSuffixElement: isSuffixElement)
        return startIndex // DUMMY because rotate is not implemented
//        return self[j..<k].rotate(shiftingToStart:i)
    }
}

// Look at swift standart library documentation and sample playground init.
// When you implement a loop think about to replace it with an algotrithm. Hunt for it. If you cant find write your own.
// You need to test your algorithm with no preconditions. The code shouldn't depend on other algorithms.

// If you want to improve the code quality in your organization, replace all of your coding guidelines with one goal: NO RAW LOOPS" -> Sean Parent, C++ Seasoning
var canvas = Canvas()
canvas.shapes.deleteSelection()
canvas.shapes.deleteSelectionElegant()
canvas.shapes.foo(arg1: "asasd", arg2: "Asdad", arg3: Shape())
canvas.shapes.bringToFront(elementsSatisfying: {$0.isSelected})
canvas.shapes.bringForward(elementsSatisfying: {$0.isSelected}) // -> Needed to make it Generic until MutableCollection
