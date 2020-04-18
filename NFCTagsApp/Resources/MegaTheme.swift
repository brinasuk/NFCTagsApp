//
//  MegaTheme.swift
//  Mega
//
//  Created by Tope Abayomi on 10/11/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class MegaTheme {
    
    /*
    HelveticaNeue-Bold,HelveticaNeue-CondensedBlack,HelveticaNeue-Medium,HelveticaNeue,HelveticaNeue-Light,HelveticaNeue-CondensedBold,HelveticaNeue-LightItalic,HelveticaNeue-UltraLightItalic,HelveticaNeue-UltraLight,HelveticaNeue-BoldItalic,HelveticaNeue-Italic
    */
    
    //newSystemBackgroundColor = .black or .yellow
    //navbarBackColor = .black or paleRoseColor
    //backgroundColor = .secondarySystemBackground or .white
    //textColor = .label or .darkText
    //mainColor = .systemRed or .blue
    //separatorColor = .systemRed or .blue
    //titleTextColor = mainColor
    //titleLargeTextColor = mainColor
    //secondaryLabel = .secondaryLabel or .darkGray
    //secondarySystemBackground = .secondarySystemBackground or .lightText
    
    class var fontName : String {
        //return "Avenir-Book"
        return "HelveticaNeue"
    }
    
    class var boldFontName : String {
        //return "Avenir-Black"
        return "HelveticaNeue-Bold"
    }
    
    class var semiBoldFontName : String {
        //return "Avenir-Heavy"
        return "HelveticaNeue-CondensedBold"
    }
    
    class var lighterFontName : String {
        //return "Avenir-Light"
        return "HelveticaNeue-Light"
    }
    
    class var darkColor : UIColor {
        //return UIColor.black
        return textColor
    }
    
    class var lightColor : UIColor {
        //return UIColor(white: 0.6, alpha: 1.0)
        return secondaryLabel
    }
    

}
