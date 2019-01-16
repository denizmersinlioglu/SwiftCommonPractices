import UIKit

class Kid{
    var nickname: String = ""
    var age: Double = 0.0
    var bestFriend: Kid? = nil
    var friends: [Kid] = []
    
    convenience init(nickname: String, age: Double){
        self.init()
        self.nickname = nickname
        self.age = age
    }
}

let nicknamePath = \Kid.nickname  // -> \BaseType.PropertyName && \.nickname -> Type Inference
let characters = \Kid.nickname.count // -> Key paths can be composed in sequence
let bestFriend = \Kid.bestFriend?.nickname // -> Optional chaining in key paths
let firstFriend = \Kid.friends[0] // -> Indirection through subscripts

var ben = Kid(nickname: "Benji", age: 6)
ben[keyPath: \Kid.nickname] = "Ben"
let mia = Kid(nickname: "Mia", age: 4.5)

let age = ben[keyPath: \Kid.age] // -> Research abouth subscripts in swift.
ben[keyPath: \Kid.nickname] = "Ben" // -> Mutate with keypath subscript.

struct BirthdayParty{
    let celebrant: Kid
    var theme: String
    var attending: [Kid]
}

var bensParty = BirthdayParty(celebrant: ben, theme: "Construction", attending: [mia])
var miasParty = BirthdayParty(celebrant: mia, theme: "Space", attending: [ben])

var birthdayKid = bensParty[keyPath: \BirthdayParty.celebrant]
bensParty[keyPath: \BirthdayParty.theme] = "Pirate"

let birthdatKidsAgeKeyPath = \BirthdayParty.celebrant.age
let birthdayBoysAge = bensParty[keyPath: birthdatKidsAgeKeyPath]
let birthdayGirlsAge = miasParty[keyPath: birthdatKidsAgeKeyPath]

//MARK: - Appending Key Paths
func partyPersonsAge(party: BirthdayParty, participantPath: KeyPath<BirthdayParty, Kid>) -> Double{
    let kidsAgeKeyPath = participantPath.appending(path: \.age) // -> Inner types of key paths needed to match.
    return party[keyPath: kidsAgeKeyPath]
}
let birthdayBoysAgeAppended = partyPersonsAge(party: bensParty, participantPath: \.celebrant)
let firstAttendeesAges = partyPersonsAge(party: bensParty, participantPath: \.attending[0])

//MARK: - Type Erased Key Paths
let themes = ["Theme", "Attending", "Birthday Kid"]
let partyPaths = [\BirthdayParty.theme, \BirthdayParty.attending, \BirthdayParty.celebrant] // -> [PartialKeyPath<BirthdayParty>]: Partially type-erased key paths

