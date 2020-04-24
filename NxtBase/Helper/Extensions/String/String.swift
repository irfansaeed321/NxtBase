//
//  String.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//
import UIKit

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
    }
    func decodeUrl() -> String {
        return self.removingPercentEncoding!
    }
}

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    var pathExtension: String {
        return fileURL.pathExtension
    }
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
}


extension String {
    var isArabic: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        return predicate.evaluate(with: self)
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
    func isBlank(text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension String {
    var isValidPhone: Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = self.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return self == filtered
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


extension String {
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

extension String {
    
    var convertToColour: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if #available(iOS 13, *) {
            guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else {return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)}
            let a, r, g, b: Int32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        } else {
            var int = UInt32()
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        }
    }
}
