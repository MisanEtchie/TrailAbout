//
//  Views+Extensions.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI

extension View {
    
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil )
    }
    
    func disableWithOpacity (_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func border (_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .stroke(color, lineWidth: width )
            )
    }
    
    func fillView (_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .fill(color)
            )
    }
    
    func hAlign (_ alignment: Alignment)-> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign (_ alignment: Alignment)-> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    
    
}

func parseBackendDateString(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy 'at' HH:mm:ss 'UTC'Z"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.date(from: dateString)
}


func timeAgoSinceDate(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    
    let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
    
    if let minutes = components.minute, minutes < 60 {
        return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
    }
    
    if let hours = components.hour, hours < 24 {
        return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
    }
    
    if let days = components.day, days < 7 {
        return days == 1 ? "1 day ago" : "\(days) days ago"
    }
    
    if let weeks = components.weekOfYear, weeks < 5 {
        return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
    }
    
    if let months = components.month, months < 12 {
        return months == 1 ? "1 month ago" : "\(months) months ago"
    }
    
    if let years = components.year {
        return years == 1 ? "1 year ago" : "\(years) years ago"
    }
    
    return date.formatted(date: .abbreviated, time: .omitted)
}
