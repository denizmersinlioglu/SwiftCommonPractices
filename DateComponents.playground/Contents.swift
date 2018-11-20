import Foundation

let calendar = Calendar.current
let dateComponents = DateComponents(calendar: calendar, year: 2018, month: 10, day: 10)

// DateComponents as a date specifier
let date = calendar.date(from: dateComponents)! // 2018-10-10 -> Its date object
print(date)



// DateComponents as a duration of time
let dateAddition = calendar.date(byAdding: dateComponents, to: date)!
print(dateAddition)

let components = calendar.dateComponents([.year, .month, .day], from: Date())
print(components)



// Getting all the date components from current date
let allDateComponents = calendar.dateComponents([.calendar, .timeZone, .era, .quarter, .year, .month, .day, .hour, .minute, .second, .nanosecond,
                                              .weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear, .yearForWeekOfYear], from: Date())
print(allDateComponents)



// Getting date from date components
// Bad
let timestamp = "2018-10-03"
let formatter = ISO8601DateFormatter()
formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
let badDate = formatter.date(from: timestamp)
print(badDate!)

// Good
let goodDateComponents = DateComponents(calendar: calendar, year: 2018, month: 10, day: 3)
let goodDate = calendar.date(from: dateComponents)
print(goodDate!)



// Getting the intervalse start-end points
// OK
let intervalDateComponents = calendar.dateComponents([.year, .month], from: Date())
let okayBeginningOfMonth = calendar.date(from: intervalDateComponents)
print(okayBeginningOfMonth!)

// Better
let betterBeginningOfMonth = calendar.dateInterval(of: .month, for: Date())?.start
print(betterBeginningOfMonth!)



// Getting the interval quantities from date components
let monthInterval = calendar.dateInterval(of: .month, for: Date())!
let hourInterval = calendar.dateComponents([.hour], from: monthInterval.start, to: monthInterval.end).hour
print(hourInterval!)



// Adding date components to get desired date
// Bad
let badTomorrow = Date().addingTimeInterval(60 * 60 * 24)
print(badTomorrow)

// Good
let goodTomorrow = calendar.date(byAdding: .day, value: 1, to: Date())
print(goodTomorrow!)

let nextYear = calendar.date(byAdding: DateComponents(year: 1), to: Date())


// Getting next match for specific date
let pedanticDateComponents = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: Date())
let yesterday = calendar.nextDate(after: Date(), matching: dateComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward)
print(yesterday!)
