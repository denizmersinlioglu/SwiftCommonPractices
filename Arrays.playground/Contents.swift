import UIKit

var str = "Hello, playground"

extension Array where Element: Numeric{
    func sum() -> Element{
        return self.reduce(0, {$0 + $1})
    }
}

extension Array where Element == String{
    func conctenate() -> Element{
        return self.reduce("", {$0 + $1 + " "})
    }
}

let floats: [CGFloat] = [1, 2.3, 3.4]
floats.sum()

let strings = ["Hello", "From", "Youtube", "Channels"]
strings.conctenate()
