//
//  AllExtentionFile.swift
//  PlayDate
//
//  Created by Pranjal on 13/06/21.
//

import Foundation

import SwiftUI



extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}


extension NSNotification {
    static let completevideo = NSNotification.Name.init("completevideo")
}

public extension FileManager {

    func temporaryFileURL(fileName: String = UUID().uuidString) -> URL? {
        return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(fileName)
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}


public extension View {
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               dismissButton: Alert.Button? = nil) -> some View {
        
        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
}


extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func chatFormate() -> String{
        //class func ChangeDateFormat(Date: String, fromFormat: String, toFormat: String ) -> String  {
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
            //let newdate = dateFormatter.date(from: Date)
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        //}
    }
    
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "y" : "\(interval)" + " " + "y"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "m" : "\(interval)" + " " + "m"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "d" : "\(interval)" + " " + "d"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "h" : "\(interval)" + " " + "h"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "min" : "\(interval)" + " " + "min"
        }
        
        return "Now"
    }
    

    func timeAgoInNotification() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
       
        if Calendar.autoupdatingCurrent.isDateInToday(self){
            return "Today"
        }
        
        if Calendar.autoupdatingCurrent.isDateInYesterday(self){
            return "Yesterday"
        }
        
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "Year Ago" : "\(interval)" + " " + "Years Ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "Month Ago" : "\(interval)" + " " + "Months Ago"
        }
        
        // Week
        if let interval = Calendar.current.dateComponents([.weekOfMonth], from: fromDate, to: toDate).weekOfMonth, interval > 0  {
                return interval == 1 ? "\(interval)" + " " + "Week Ago" : "\(interval)" + " " + "Weeks Ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day, .hour, .minute], from: fromDate, to: toDate).day, interval > 0  {
                return interval == 1 ? "\(interval)" + " " + "Day Ago" : "\(interval)" + " " + "Days Ago"
        }
        
        return "Now"
    }
    
}


//MARK:- Remove duplicate ids
extension Array {
    func uniqueIDSRemove<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


extension Date {
    var time: String { return Formatter.time.string(from: self) }
    var year:    Int { return Calendar.autoupdatingCurrent.component(.year,   from: self) }
    var month:   Int { return Calendar.autoupdatingCurrent.component(.month,  from: self) }
    var day:     Int { return Calendar.autoupdatingCurrent.component(.day,    from: self) }
    var elapsedTime: String {
        if timeIntervalSinceNow > -60.0  { return "Just Now" }
        if isInToday                 { return "Today at \(time)" }
        if isInYesterday             { return "Yesterday at \(time)" }
        return (Formatter.dateComponents.string(from: Date().timeIntervalSince(self)) ?? "") + " ago"
    }
    var isInToday: Bool {
        return Calendar.autoupdatingCurrent.isDateInToday(self)
    }
    var isInYesterday: Bool {
        return Calendar.autoupdatingCurrent.isDateInYesterday(self)
    }
}


extension Formatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    static let dateComponents: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.zeroFormattingBehavior = .default
        formatter.allowsFractionalUnits = false
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        return formatter
    }()
}
