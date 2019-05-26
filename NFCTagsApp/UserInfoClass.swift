//  Converted to Swift 5 by Swiftify v5.0.39155 - https://objectivec2swift.com/
//
//  UserInfoClass.swift
//  BH4ME7
//
//  Created by Alex Levy on 4/27/14.
//  Copyright (c) 2014 Hillside Software. All rights reserved.
//
//alex
//
//  UserInfoClass.swift
//  BH4ME7
//
//  Created by Alex Levy on 4/27/14.
//  Copyright (c) 2014 Hillside Software. All rights reserved.
//
// Change
//#import "Appdelegate.h"

import Foundation
import UIKit
//alex test

//private let SERVERFILENAME = "https://photos.homecards.com/rebeacons/"

class UserInfoClass: NSObject {
    //-(NSString *)urlEncodeX:(NSString *)urlString;
    func urlEncodeURL(_ fullURL: String?) -> String? {

        if (fullURL?.count ?? 0) == 0 {
            return ""
        }

        let fullUrlString = fullURL
        var uriPart = ""
        var queryPart = ""
        let n: Int = indexOf("?", within: fullURL)
        if n > 0 {
            uriPart = (fullUrlString as? NSString)?.substring(to: n) ?? ""
            queryPart = (fullUrlString as? NSString)?.substring(from: n) ?? ""
        } else {
            uriPart = ""
            queryPart = fullURL ?? ""
        }
        //NSLog(@"URI: %@",uriPart);
        //NSLog(@"QUERY: %@",queryPart);



        // You need to encode the parts of the string - NOT the ENTIRE string at once
        // Start by breaking it up by &
        // Then encode eich piece after the =
        // Then put it all together again

        //STRIP OFF LEADING & (If there is one)
        let firstChar = (queryPart as? NSString)?.substring(to: 1)
        if (firstChar == "&") {
            queryPart = (queryPart as? NSString)?.substring(from: 1) ?? ""
        }

        //PAIRS
        let pairs = queryPart.components(separatedBy: "&")

        var work: String //Contains Feat\Code
        var lhs: String
        var rhs: String
        var componentPair: [Any]
        var ans = "&"

        for rowCounter in 0..<pairs.count {
            work = pairs[rowCounter]
            //NSLog(@"WORK: %d  %@",rowCounter,work);
            componentPair = work.components(separatedBy: "=")
            lhs = componentPair[0] as? String ?? ""
            rhs = componentPair[1] as? String ?? ""
            rhs = urlEncodeX(rhs) ?? ""
            ans = ans + (lhs)
            ans = ans + ("=")
            ans = ans + (rhs)
            ans = ans + ("&")
        }

        // Remove any trailing &
        if ans.count > 0 {
            if (((ans as? NSString)?.substring(from: ans.count - 1)) == "&") {
                ans = (ans as? NSString)?.substring(to: ans.count - 1) ?? ""
            }
        }

        if uriPart.count > 0 {
            ans = uriPart + (queryPart)
        }

        //NSLog(@"ANS==>> %@",ans);
        return ans
    }

    func localPrice(_ priceString: String?) -> String? {
        if priceString == nil {
            return ""
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = NSLocale.current
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.alwaysShowsDecimalSeparator = false
        currencyFormatter.numberStyle = .currency
        let numericOnly = priceString?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let f = NumberFormatter()
        f.numberStyle = .decimal
        let myNumber = f.number(from: numericOnly ?? "")
        var formattedPrice: String? = nil
        if let myNumber = myNumber {
            formattedPrice = currencyFormatter.string(from: myNumber)
        }
        if formattedPrice == nil {
            formattedPrice = "" //CRITICAL LINE!
        } else {
            formattedPrice = "From " + (formattedPrice ?? "")
        }
        return formattedPrice
    }

//    func documentsFilePath(_ fileName: String?) -> String? {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let docDir = paths[0]
//        let docFile = URL(fileURLWithPath: docDir).appendingPathComponent(fileName).absoluteString
//        return docFile
//    }

//    func getHexcode(_ mycolor: UIColor?) -> String? {
//        let components = mycolor?.cgColor.components
//        let r: CGFloat? = components?[0]
//        let g: CGFloat? = components?[1]
//        let b: CGFloat? = components?[2]
//
//        let colorHexCode = String(format: "#%02lX%02lX%02lX", Int(r * 255.0), Int(g * 255.0), Int(b * 255.0))
//
//        return colorHexCode
//    }

//    func color(fromHexString hexString: String?) -> UIColor? {
//        var rgbValue: UInt = 0
//        let defaultColor = "#FF0000"
//
//        if hexString?.isEqual("") ?? false {
//            hexString = defaultColor
//        }
//
//        if (hexString is NSNull) {
//            hexString = defaultColor
//        }
//
//        let scanner = Scanner(string: hexString ?? "")
//        scanner.scanLocation = 1 // bypass '#' character
//        scanner.scanHexInt32(&rgbValue)
//
//        return UIColor(red: Double(((rgbValue & 0xff0000) >> 16)) / 255.0, green: Double(((rgbValue & 0xff00) >> 8)) / 255.0, blue: Double((rgbValue & 0xff)) / 255.0, alpha: 1.0)
//    }

//    func createPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
//        if useID == nil {
//            return nil
//        }
//        var url = ""
//        url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
//        //NSLog(@"URL: %@",url);
//        return url
//
//    }

    func createImageURL(_ useAction: String?, withID useID: String?) -> String? {
        if useID == nil {
            return nil
        }

        var url = ""
        url = "\(SERVERFILENAME)\(useAction ?? "")-\(useID ?? "")-1.jpg"
        return url


    }

//    func createFileName(withAction useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
//        if useID == nil {
//            return nil
//        }
//        let url = String(format: "%@-%@-%ld.jpg", useAction ?? "", useID ?? "", useNumber)
//        return url
//    }

    func createAudioFileName(withAction useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        let url = String(format: "%@-%@-%ld.m4a", useAction ?? "", useID ?? "", useNumber)
        return url
    }

    func createAudioPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        var url = ""
        url = String(format: "%@%@-%@-%ld.m4a", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        return url
    }

    func createFloorPlanURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        var url = ""
        url = String(format: "%@%@-%@-%ld.png", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        return url
    }

    func createFloorPlanName(withAction useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        let url = String(format: "%@-%@-%ld.png", useAction ?? "", useID ?? "", useNumber)
        return url
    }

//    func image(with image: UIImage?, scaledTo newSize: CGSize) -> UIImage? {
//        if UIScreen.main.responds(to: #selector(UIScreen.scale)) {
//            if UIScreen.main.scale == 2.0 {
//                UIGraphicsBeginImageContextWithOptions(newSize, _: true, _: 2.0)
//            } else {
//                UIGraphicsBeginImageContext(newSize)
//            }
//        } else {
//            UIGraphicsBeginImageContext(newSize)
//        }
//        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }

    func indexOf(_ subString: String?, within mainString: String?) -> Int {

        //    The location field is the location, or index, of the NSRange - in your case it is the index of the string "." within the original string. The length field is the length of the range that the NSRange implements.
        //    NSInteger n = [self indexOf:@"?" withinString:fullURL];
        let index: NSRange? = (mainString as NSString?)?.range(of: subString ?? "", options: .literal)

        if index?.location == NSNotFound {
            return -1
        }
        return (index?.location ?? 0) + 1
    }

    func urlEncodeX(_ urlString: String?) -> String? {

        //BE CAREFUL: THIS MAY NOT ALWAYS WORK. USE urlEncodeURL
        var value = urlString
        value = value?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        //    NSString *url = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
        //                                                                                          (__bridge CFStringRef)urlString,
        //                                                                                          NULL,
        //                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
        //                                                                                          kCFStringEncodingUTF8);  //URLENCODE

        return value
    }

    //- (NSString *)formatDate:(NSDate *)theDate
    //{
    //	static NSDateFormatter *formatter;
    //	if (formatter == nil) {
    //		formatter = [[NSDateFormatter alloc] init];
    //		[formatter setDateStyle:NSDateFormatterMediumStyle];
    //		[formatter setTimeStyle:NSDateFormatterNoStyle];
    //	}
    //
    //	return [formatter stringFromDate:theDate];
    //}
}
