import UIKit

struct Country {
    let name: String
    let capital: String
    var visited: Bool
}

extension Country: Comparable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name &&
            lhs.capital == rhs.capital &&
            lhs.visited == rhs.visited
    }
    
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.name < rhs.name ||
            (lhs.name == rhs.name && lhs.capital < rhs.capital) ||
            (lhs.name == rhs.name && lhs.capital == rhs.capital && rhs.visited)
    }
}
let canada = Country(name: "Canada", capital: "Ottawa", visited: true)
let australia = Country(name: "Australia", capital: "Canberra", visited: false)

let brazil = Country(name: "Brazil", capital: "Rio", visited: true)
let egypt = Country(name: "Egypt", capital: "Tahran", visited: false)
let uk = Country(name: "United Kingdom", capital: "London", visited: true)
let france = Country(name: "France", capital: "Paris", visited: false)

let bucketList = [brazil,australia,canada,egypt,uk,france]

// Long way
let object = canada
let containsObject = bucketList.contains {
    return $0.name == object.name &&
        $0.capital == object.capital &&
        $0.visited == object.visited
}

// Short hand with comparable implementation of Country object
bucketList.contains(canada)
