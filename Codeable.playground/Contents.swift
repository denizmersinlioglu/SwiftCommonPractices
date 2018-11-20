import UIKit

struct Employee {
    var name: String
    var id: Int
    var favoriteToy: Toy
    
    enum CodingKeys: String, CodingKey{
        case id = "employeeId"
        case name = "employeeName"
        case gift = "giftName"
    }
}

extension Employee: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(favoriteToy.name, forKey: .gift)
    }
}

extension Employee: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(Int.self, forKey: .id)
        let gift = try values.decode(String.self, forKey: .gift)
        favoriteToy = Toy(name: gift)
    }
}

struct Toy: Codable {
    var name: String
}

let toy1 = Toy(name: "Teddy")
let employee = Employee(name: "Deniz", id: 1, favoriteToy: toy1)

let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(employee)

let jsonString = String(data: jsonData, encoding: .utf8)

print(jsonData)
print(jsonString)

let jsonDecoder = JSONDecoder()
let employee2 = try jsonDecoder.decode(Employee.self, from: jsonData)

print(employee2)
