import UIKit

// Deriving dependent states

struct Contact {
    typealias ID = Int
    
    struct Group{
        struct Name: Hashable{ }
    }
    
    let id: ID
    var firstName: String
    var lastName: String
    var fullName: String { "\(firstName) \(lastName)" } // Resolve inconsistency first last name
    var emailAddress: String
}
// Recomputing the value may cost much with large collections!!

struct Leaderboard {
    typealias Entry = (name: String, score: Int)

    // Each time that our array of entries gets modified, we
    // re-compute the current average score:
    var entries: [Entry] {
        didSet { updateAverageScore() }
    }
    
    // By marking our property as 'private(set)', we prevent it
    // from being mutated outside of this type:
    private(set) var averageScore = 0

    init(entries: [Entry]) {
        self.entries = entries
        // Property observers don't get triggered as part of
        // initializers, so we have to call our update method
        // manually here:
        updateAverageScore()
    }

    private mutating func updateAverageScore() {
        guard !entries.isEmpty else {
            averageScore = 0
            return
        }

        let totalScore = entries.reduce(into: 0) { score, entry in
            score += entry.score
        }

        averageScore = totalScore / entries.count
    }
}
// As that sort of logic is now baked into the models themselves.

struct Contact2 {
    let id: Int
     var emailAddress: String
    
    var firstName: String {
        didSet{ fullName = "\(firstName) \(lastName)" }
    }
    var lastName: String {
        didSet{ fullName = "\(firstName) \(lastName)" }
    }
    
    private(set) var fullName: String = ""
   
}

class ContactList {
    var name: String
    var contacts = [Contact.ID : Contact]()
    var favoriteIDs = Set<Contact.ID>()
    var groups = [Contact.Group.Name : Contact.Group]()

    init(name: String) {
        self.name = name
    }
}
// Above we’re making use of nested types in order to make types like Group and Name more contextual and “self-documenting”.
