//
//  Colors.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/18/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

//SEE ALSO http://www.flatuicolorpicker.com/ and https://color.adobe.com

import UIKit

/*
HelveticaNeue-Bold,HelveticaNeue-CondensedBlack,HelveticaNeue-Medium,HelveticaNeue,HelveticaNeue-Light,HelveticaNeue-CondensedBold,HelveticaNeue-LightItalic,HelveticaNeue-UltraLightItalic,HelveticaNeue-UltraLight,HelveticaNeue-BoldItalic,HelveticaNeue-Italic
*/

/*
// MARK:  - System Colors
public let infoBlueColor = UIColor(red:47, green:112, blue:225)
public let successColor = UIColor(red:83, green:215, blue:106)
public let warningColor = UIColor(red:221, green:170, blue:59)
public let dangerColor = UIColor(red:229, green:0, blue:15)

// MARK:  mark - Whites
public let antiqueWhiteColor = UIColor(red:250, green:235, blue:215)
public let oldLaceColor = UIColor(red:253, green:245, blue:230)
public let ivoryColor = UIColor(red:255, green:255, blue:240)
public let seashellColor = UIColor(red:255, green:245, blue:238)
public let ghostWhiteColor = UIColor(red:248, green:248, blue:255)
public let snowColor = UIColor(red:255, green:250, blue:250)
public let linenColor = UIColor(red:250, green:240, blue:230)


// MARK:  - Grays
public let black25PercentColor = UIColor(red:0, green:0, blue:0)
public let black50PercentColor = UIColor(red:0, green:0, blue:0)
public let black75PercentColor = UIColor(red:0, green:0, blue:0)
public let warmGrayColor = UIColor(red:133, green:117, blue:112)
public let coolGrayColor = UIColor(red:118, green:122, blue:133)
public let charcoalColor = UIColor(red:34, green:34, blue:34)

// MARK:  Blues
public let tealColor = UIColor(red:28, green:160, blue:170)
public let steelBlueColor = UIColor(red:103, green:153, blue:170)
public let robinEggColor = UIColor(red:141, green:218, blue:247)
public let pastelBlueColor = UIColor(red:99, green:161, blue:247)
public let turquoiseColor = UIColor(red:112, green:219, blue:219)
public let skyBlueColor = UIColor(red:0, green:178, blue:238)
public let indigoColor = UIColor(red:13, green:79, blue:139)
public let denimColor = UIColor(red:67, green:114, blue:170)
public let blueberryColor = UIColor(red:89, green:113, blue:173)
public let cornflowerColor = UIColor(red:100, green:149, blue:237)
public let babyBlueColor = UIColor(red:190, green:220, blue:230)
public let midnightBlueColor = UIColor(red:13, green:26, blue:35)
public let fadedBlueColor = UIColor(red:23, green:137, blue:155)
public let icebergColor = UIColor(red:200, green:213, blue:219)
public let waveColor = UIColor(red:102, green:169, blue:251)

// MARK: Greens
public let emeraldColor = UIColor(red:1, green:152, blue:117)
public let grassColor = UIColor(red:99, green:214, blue:74)
public let pastelGreenColor = UIColor(red:126, green:242, blue:124)
public let seafoamColor = UIColor(red:77, green:226, blue:140)
public let paleGreenColor = UIColor(red:176, green:226, blue:172)
public let cactusGreenColor = UIColor(red:99, green:111, blue:87)
public let chartreuseColor = UIColor(red:69, green:139, blue:0)
public let hollyGreenColor = UIColor(red:32, green:87, blue:14)
public let oliveColor = UIColor(red:91, green:114, blue:34)
public let oliveDrabColor = UIColor(red:107, green:142, blue:35)
public let moneyGreenColor = UIColor(red:134, green:198, blue:124)
public let honeydewColor = UIColor(red:216, green:255, blue:231)
public let limeColor = UIColor(red:56, green:237, blue:56)
public let cardTableColor = UIColor(red:87, green:121, blue:107)

// MARK: Reds
public let salmonColor = UIColor(red:233, green:87, blue:95)
public let brickRedColor = UIColor(red:151, green:27, blue:16)
public let easterPinkColor = UIColor(red:241, green:167, blue:162)
public let grapefruitColor = UIColor(red:228, green:31, blue:54)
public let pinkColor = UIColor(red:255, green:95, blue:154)
public let indianRedColor = UIColor(red:205, green:92, blue:92)
public let strawberryColor = UIColor(red:190, green:38, blue:37)
public let coralColor = UIColor(red:240, green:128, blue:128)
public let maroonColor = UIColor(red:80, green:4, blue:28)
public let watermelonColor = UIColor(red:242, green:71, blue:63)
public let tomatoColor = UIColor(red:255, green:99, blue:71)
public let pinkLipstickColor = UIColor(red:255, green:105, blue:180)
public let paleRoseColor = UIColor(red:255, green:228, blue:225)
public let crimsonColor = UIColor(red:187, green:18, blue:36)

// MARK: Purples
public let eggplantColor = UIColor(red:105, green:5, blue:98)
public let pastelPurpleColor = UIColor(red:207, green:100, blue:235)
public let palePurpleColor = UIColor(red:229, green:180, blue:235)
public let coolPurpleColor = UIColor(red:140, green:93, blue:228)
public let violetColor = UIColor(red:191, green:95, blue:255)
public let plumColor = UIColor(red:139, green:102, blue:139)
public let lavenderColor = UIColor(red:204, green:153, blue:204)
public let raspberryColor = UIColor(red:135, green:38, blue:87)
public let fuschiaColor = UIColor(red:255, green:20, blue:147)
public let grapeColor = UIColor(red:54, green:11, blue:88)
public let periwinkleColor = UIColor(red:135, green:159, blue:237)
public let orchidColor = UIColor(red:218, green:112, blue:214)


// MARK: Yellows
public let goldenrodColor = UIColor(red:215, green:170, blue:51)
public let yellowGreenColor = UIColor(red:192, green:242, blue:39)
public let bananaColor = UIColor(red:229, green:227, blue:58)
public let mustardColor = UIColor(red:205, green:171, blue:45)
public let buttermilkColor = UIColor(red:254, green:241, blue:181)
public let goldColor = UIColor(red:139, green:117, blue:18)
public let creamColor = UIColor(red:240, green:226, blue:187)
public let lightCreamColor = UIColor(red:240, green:238, blue:215)
public let wheatColor = UIColor(red:240, green:238, blue:215)
public let beigeColor = UIColor(red:245, green:245, blue:220)


// MARK: Oranges
public let peachColor = UIColor(red:242, green:187, blue:97)
public let burntOrangeColor = UIColor(red:184, green:102, blue:37)
public let pastelOrangeColor = UIColor(red:248, green:197, blue:143)
public let cantaloupeColor = UIColor(red:250, green:154, blue:79)
public let carrotColor = UIColor(red:237, green:145, blue:33)
public let mandarinColor = UIColor(red:247, green:145, blue:55)


// MARK: Browns
public let chiliPowderColor = UIColor(red:199, green:63, blue:23)
public let burntSiennaColor = UIColor(red:138, green:54, blue:15)
public let chocolateColor = UIColor(red:94, green:38, blue:5)
public let coffeeColor = UIColor(red:141, green:60, blue:15)
public let cinnamonColor = UIColor(red:123, green:63, blue:9)
public let almondColor = UIColor(red:196, green:142, blue:72)
public let eggshellColor = UIColor(red:252, green:230, blue:201)
public let sandColor = UIColor(red:222, green:182, blue:151)
public let mudColor = UIColor(red:70, green:45, blue:29)
public let siennaColor = UIColor(red:160, green:82, blue:45)
public let dustColor = UIColor(red:236, green:214, blue:197)
 
 // MARK: Browns
 public let royalBlue = UIColor(red:83, green:51, blue:237)
//Example: let myColor = royalBlue

*/

extension UIColor {
    static var customAccent: UIColor { return MaterialUI.orange600 }
}

fileprivate enum MaterialUI {
    static let orange600 = UIColor(red:   0xFB / 0xFF,
                                   green: 0x8C / 0xFF,
                                   blue:  0x00 / 0xFF,
                                   alpha: 1) // #FB8C00
}

//systemBackground #000000ff  rgba(0.0, 0.0, 0.0, 1.0)
//systemBackground #1c1c1eff  rgba(28.0, 28.0, 30.0, 1.0)

let systemBackground = UIColor(hex: "#1c1c1eff ")

let blue = UIColor(hex: "#BBDEFB")
let darkBlue = UIColor(hex: "#0D47A1")

//private let orange600 = UIColor(red:   0xFB / 0xFF,
//                               green: 0x8C / 0xFF,
//                               blue:  0x00 / 0xFF,
//                               alpha: 1) // #FB8C00

public var newPaleRoseColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                 return MaterialUI.orange600  //was 300
            } else {
                return  blue //MaterialUI.orange600
            }
        }
    } else {
        return MaterialUI.orange600
    }
}

/*
 //=======================================//
 // THIS IS THE VARIABLE TO CHANGE BACKGROUND COLOR!!
 kAppDelegate.navbarBackColor = .black //iOS13 BUG! CANNOT USE .systemBackground. DOES NOT WORK. GIVES A LIGHT BACKGROUND !!!!
 //=======================================//
 
 kAppDelegate.textColor = .label
 kAppDelegate.mainColor = .systemRed
 kAppDelegate.separatorColor? = .systemRed
 kAppDelegate.titleTextColor = kAppDelegate.mainColor
 kAppDelegate.titleLargeTextColor = kAppDelegate.mainColor
 
 
 kAppDelegate.navbarBackColor = paleRoseColor //newPaleRoseColor
 //=======================================//
 
 kAppDelegate.textColor = .white
 kAppDelegate.mainColor = .blue
 kAppDelegate.separatorColor? = .red
 kAppDelegate.titleTextColor = kAppDelegate.mainColor
 kAppDelegate.titleLargeTextColor = kAppDelegate.mainColor
 */

public let paleRoseColor = UIColor(red:255, green:228, blue:225)
public let coralColor = UIColor(red:240, green:128, blue:128)
public let royalBlue = UIColor(red:83, green:51, blue:237)

public var newSystemBackgroundColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .black  //MaterialUI.orange600  //was 300
            } else {
                return  .yellow //MaterialUI.orange600
            }
        }
    } else {
        return .white
    }
}

public var navbarBackColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .black
            } else {
                return  paleRoseColor
            }
        }
    } else {
        return paleRoseColor
    }
}
//myBackgroundColor
public var backgroundColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .secondarySystemBackground
            } else {
                return  .white
            }
        }
    } else {
        return .white
    }
}
public var textColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .label
            } else {
                return  .darkText
            }
        }
    } else {
        return .white
    }
}
public var mainColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .systemRed
            } else {
                return  .blue
            }
        }
    } else {
        return .blue
    }
}
public var separatorColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .systemRed
            } else {
                return  .blue
            }
        }
    } else {
        return .blue
    }
}
public var titleTextColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return mainColor
            } else {
                return  mainColor
            }
        }
    } else {
        return mainColor
    }
}
public var titleLargeTextColor: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return mainColor
            } else {
                return  mainColor
            }
        }
    } else {
        return mainColor
    }
}

public var secondaryLabel: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .secondaryLabel
            } else {
                return  .darkGray
            }
        }
    } else {
        return mainColor
    }
}

public var secondarySystemBackground: UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            //if traitCollection.userInterfaceStyle == .dark {
            if (kAppDelegate.isDarkMode == true)  {
                return .secondarySystemBackground
            } else {
                return  .lightText
            }
        }
    } else {
        return mainColor
    }
}

extension UIColor {
    public convenience init?(hexValue: String) {
        let r, g, b, a: CGFloat

        if hexValue.hasPrefix("#") {
            let start = hexValue.index(hexValue.startIndex, offsetBy: 1)
            let hexColor = String(hexValue[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


