import Foundation
// WWDC 2017: Whats New in Foundation

// (??) Research what is @objcMembers and dynamic means
// Also Watch -> What is new in Cocoa && Efficient Interactions with Frameworks
@objcMembers
class Kid: NSObject{
    dynamic var nickname: String = ""
    dynamic var age: Double = 0.0
    dynamic var bestFriend: Kid? = nil
    dynamic var friends: [Kid] = []
    
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
let asd = ben[keyPath: nicknamePath]
ben[keyPath: \Kid.nickname] = "Ben"
let mia = Kid(nickname: "Mia", age: 6.5)

let age = ben[keyPath: \Kid.age] // -> (??) Research about subscripts in swift.
ben[keyPath: \Kid.nickname] = "Ben" // -> Mutate with keypath subscript.

struct BirthdayParty{
    var celebrant: Kid
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
let titles = ["Theme", "Attending", "Birthday Kid"]
let partyPaths = [\BirthdayParty.theme, \BirthdayParty.attending, \BirthdayParty.celebrant]
// -> [PartialKeyPath<BirthdayParty>]: Partially type-erased key paths
// PartialKeyPaths know abouth their base type, but they can point to any valid key path for that particular base.

for (title, partyPath) in zip(titles, partyPaths){
    let partyValue = miasParty[keyPath: partyPath]
    print("\(title) -> \(partyValue)\n")
}

extension BirthdayParty{
    // Solve1: func blowCandles(ageKeyPath: ReferenceWritableKeyPath<BirthdayParty, Double>){} -> Using a ReferenceWritableKeyPath enables to change reference value.
    // Solve2: mutating func blowCandles(ageKeyPath: WritableKeyPath<BirthdayParty, Double>){} -> not a right thing because we don't mutate the BirthdayPaty: (Struct: Value Type)
    mutating func blowCandles(ageKeyPath: ReferenceWritableKeyPath<BirthdayParty, Double>){
        let oldAge = self[keyPath: ageKeyPath]
        self[keyPath: ageKeyPath] = floor(oldAge) + 1.0
    }
}

bensParty.blowCandles(ageKeyPath: \.celebrant.age)
print(bensParty[keyPath: \BirthdayParty.celebrant.age])

// WritableKeyPath: Write directly into value-type base (inout/mutating)
// ReferenceWritableKeyPath: Simply invokes a property setter on the reference type. -> Write into a reference-type base.
// Inheritence Tree: AnyKeyPath -> PartialKeyPath<Base> -> KeyPath<Base, Property> -> WritableKeyPath<Base, Property> -> ReferenceWritableKeyPath<Base, Property>
// AnyKeyPath -> Fully type erased key path: Multiple bases and multiple properties.


//MARK: Key Value Observing
// KVO: Cocoa's way of allowing objects to establish relationships to be notified about changes in their state.
// Let consider when mias age changes.
// Observe can be used in NSObject subclass. When you set the observation nil, the observation will toward down: Unregistering observation.
// observation = (Observe using key path) {reaction closure}
let observation = mia.observe(\.age) { observed, change in
    // observed is same reference with mia, but it is given as parameter to prevent retain cycles.
}

@objcMembers class KindergartenController: NSObject{
    dynamic var representedKid: Kid
    var ageObservation: NSKeyValueObservation?
    
    init(representedKid: Kid){
        self.representedKid = representedKid
    }
    
    convenience init(kid: Kid) {
        self.init(representedKid: kid)
        ageObservation = observe(\.representedKid.age) { observed, change in
            if observed.representedKid.age > 5 {
                print("Happy birthday \(observed.representedKid.nickname)! Time for kindergarten")
            }
        }
    }
}

let controller = KindergartenController(kid: mia)
miasParty.blowCandles(ageKeyPath: \.celebrant.age)

//MARK: - String Key Path
let stringKeyPath = #keyPath(Kid.nickname)
