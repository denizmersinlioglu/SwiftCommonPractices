import Foundation

class Person: NSObject {
    let firstName: String
    let lastName: String
    let age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    override var description: String {
        return "\(firstName) \(lastName)"
    }
}

let alice = Person(firstName: "Alice", lastName: "Smith", age: 24)
let bob = Person(firstName: "Bob", lastName: "Jones", age: 27)
let charlie = Person(firstName: "Charlie", lastName: "Smith", age: 33)
let quentin = Person(firstName: "Quentin", lastName: "Alberts", age: 31)
let people = [alice, bob, charlie, quentin]

let bobPredicate = NSPredicate(format: "firstName = 'Bob'")
let smithPredicate = NSPredicate(format: "lastName = %@", "Smith")
let thirtiesPredicate = NSPredicate(format: "age >= 30")

var array = people as NSArray
//array.filtered(using: bobPredicate)
// ["Bob Jones"]

array.filtered(using: smithPredicate)
// ["Alice Smith", "Charlie Smith"]

(people as NSArray).filtered(using: thirtiesPredicate)
// ["Charlie Smith", "Quentin Alberts"]

let ageIs33Predicate = NSPredicate(format: "%K = %@", "age", "33")

(people as NSArray).filtered(using: ageIs33Predicate)

let namesBeginningWithLetterPredicate = NSPredicate(format: "(firstName BEGINSWITH[cd] $letter) OR (lastName BEGINSWITH[cd] $letter)")

(people as NSArray).filtered(using: namesBeginningWithLetterPredicate.withSubstitutionVariables(["letter": "A"]))
