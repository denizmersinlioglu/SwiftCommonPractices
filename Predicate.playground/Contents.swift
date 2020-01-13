import UIKit
import Foundation

// LINK: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/AdditionalChapters/Introduction.html#//apple_ref/doc/uid/TP40001789

// - A comparison predicate compares two expressions using an operator.
// - A compound predicate compares the results of evaluating two or more other predicates, or negates another predicate.

// Key-value coding: Indirectly accessing an object's attributes and relationships using string identifiers.
// Cocoa provides NSPredicate and its two subclasses, NSComparisonPredicate and NSCompoundPredicate.


class KVCExample: NSObject{
    
    override func value(forKey key: String) -> Any? {
        super.value(forKey: key)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}

// LINK: https://www.swiftbysundell.com/articles/predicates-in-swift/
// predicate: Predication (computer architecture), a choice to execute or not to execute a given instruction based on the content of a machine register


// Filtering a collection of models
extension Date {
    static var now: Date { Date() }
}

struct TodoItem{
    var tags: [String]
    var isCompleted: Bool
    var dueDate: Date
    var priority: Int
}

struct TodoList {
    var name: String
    private var items = [TodoItem]()
    
    init(name: String) {
        self.name = name
    }

    // Classic implementation that doesn't use predicate.
    // We can create a more swifty implementation for our API with predicates.
    func futureItems(basedOnDate date: Date = .now) -> [TodoItem] {
        items.filter { !$0.isCompleted && $0.dueDate > date } // Note that single line functions do not have return key word.
    }

    func overdueItems(basedOnDate date: Date = .now) -> [TodoItem] {
        items.filter { !$0.isCompleted && $0.dueDate < date }
    }

    func itemsTaggedWith(_ tag: String) -> [TodoItem] {
        items.filter { $0.tags.contains(tag) }
    }
}



// Before we can apply a predicate to our array, we must
// first convert it into an Objective-C-based NSArray:
let list = TodoList(name: "CheckList")

let array = NSArray(array: [TodoItem]())

let overdueItems = array.filtered(using: NSPredicate(
    format: "isCompleted == false && dueDate < %@",
    NSDate()
))
// NSPredicate -> A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.
// String based queries used to retrieve data. -> Don't have compile time safety.
// Need to turn our objects to NSObjects -> Can't use value semantics and require conform to objc conventions. -> Enable dynamic string-base access to our properties.


// typealias Predicate<T> = (T) -> Bool //It is abstracted as a function returns a bool for given value

struct Predicate<Target> {
    var matches: (Target) -> Bool

    init(matcher: @escaping (Target) -> Bool) {
        matches = matcher
    }
}

extension TodoList{
    func items(matching predicate: Predicate<TodoItem>) -> [TodoItem]{
        items.filter(predicate.matches)
    }
}



let overdueItems1 = list.items(matching: Predicate{ !$0.isCompleted && $0.dueDate < .now })

// Static properties and factory methods and Generic Type constrainst
// Construct predicates in a central space.
extension Predicate where Target == TodoItem{
    static var isOverdue: Self{
        Predicate {$0.isCompleted && $0.dueDate < .now}
    }
}

let overdueItems2 = list.items(matching: .isOverdue) // Consistancy and ease the call site.


// Expressive Operators
func ==<T, V: Equatable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] == rhs }
}

let uncompletedItems = list.items(matching: \.isCompleted == false)


prefix func !<T>(rhs: KeyPath<T, Bool>) -> Predicate<T> {
    rhs == false
}

let uncompletedItems1 = list.items(matching: !\.isCompleted)

func ><T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] > rhs }
}

func <<T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] < rhs }
}

let highPriorityItems = list.items(matching: \.priority > 5)


// Composition Built-in
func &&<T>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    Predicate { lhs.matches($0) && rhs.matches($0) }
}

func ||<T>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    Predicate { lhs.matches($0) || rhs.matches($0) }
}
let futureItems = list.items(
    matching: !\.isCompleted && \.dueDate > .now
)

let overdueItems3 = list.items(
    matching: !\.isCompleted && \.dueDate < .now
)

//let myTasks = list.items(
//    matching: \.creator == .currentUser || \.assignedTo == .currentUser
//)

extension Predicate where Target == TodoItem {
    static func isOverdue(
        comparedTo date: Date = .now,
        inlcudingCompleted includeCompleted: Bool = false
    ) -> Self {
        Predicate {
            if !includeCompleted {
                guard !$0.isCompleted else { return false }
            }

            return $0.dueDate < date
        }
    }
}

let overdueItems4 = list.items(matching: .isOverdue())

// An Expandable Pattern
func ~=<T, V: Collection>(
    lhs: KeyPath<T, V>, rhs: V.Element
) -> Predicate<T> where V.Element: Equatable {
    Predicate { $0[keyPath: lhs].contains(rhs) }
}

let importantItems = list.items(matching: \.tags ~= "important")


let strings: [String] = ["Deniz", "Mersinli", "as", "ASD"]
let predicate: Predicate<String> = \.count > 3

strings.filter(predicate.matches)
strings.drop(while: predicate.matches)
strings.prefix(while: predicate.matches)
strings.contains(where: predicate.matches)
