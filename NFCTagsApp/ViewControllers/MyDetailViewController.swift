//
//  MyDetailViewController.swift
//  NFCTagsApp
//
//  Created by Alex Levy on 5/26/19.
//  Copyright © 2019 Hillside Software. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MyDetailViewController: UIViewController {
    

    @IBOutlet weak var headerView: TagDetailHeaderView!
    @IBOutlet weak var tableView: UITableView!
    var tag = TagModel()
    
    var myNameLabel:String?
    
    //var restaurant = Restaurant()
//    @IBOutlet weak var headerView: RestaurantDetailHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.nameLabel.text = tag.tagTitle
        headerView.typeLabel.text = "POOCHIE"
        //headerView.headerImageView.image = UIImage(named: "restaurant")
        

        let tagPhotoRef = tag.tagPhotoRef
        
        let cloudinaryAction = "Tag"
        let usePhotoRef:String? = tagPhotoRef
        let photoNumber = 1
        let propertyPhotoFileUrl:String? = createPhotoURL(cloudinaryAction, withID: usePhotoRef, withNumber: photoNumber) ?? ""
        
//        cell.tagImageView.layer.cornerRadius = cell.tagImageView.frame.size.width / 4
//        cell.tagImageView.layer.masksToBounds = true
//        cell.tagImageView.clipsToBounds = true
        
        // METHOD 1: ======================================
//                let url = URL(string: propertyPhotoFileUrl!)!
//                headerView.headerImageView.image = resizedImage(at: url, for: CGSize(width: 375,height: 358))
        //=================================================
        
        // METHOD 2: ======================================
        let url = URL(string: propertyPhotoFileUrl!)!
        let placeholderImage = UIImage(named: "Photo-Unavailbale-300-Square")!
        headerView.headerImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        //=================================================
        
        //romee2
        

        // Do any additional setup after loading the view.
    }
    
    func createPhotoURL(_ useAction: String?, withID useID: String?, withNumber useNumber: Int) -> String? {
        if useID == nil {
            return nil
        }
        var url = ""
        url = String(format: "%@%@-%@-%ld.jpg", SERVERFILENAME, useAction ?? "", useID ?? "", useNumber)
        //NSLog(@"URL: %@",url);
        return url
        
    }
    
    func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
        
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
            else {
                return nil
        }
        
        return UIImage(cgImage: image)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
