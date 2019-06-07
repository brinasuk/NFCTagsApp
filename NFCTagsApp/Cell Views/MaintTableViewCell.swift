//  Converted to Swift 5 by Swiftify v5.0.23396 - https://objectivec2swift.com/
//
//  MaintTableViewCell.swift
//  Tap2View
//
//  Created by Alex Levy on 3/12/18.
//  Copyright © 2018 Hillside Software. All rights reserved.
//

import UIKit

class MaintTableViewCell: UITableViewCell {
    //@property (weak, nonatomic) IBOutlet UILabel *tagNumber;
    //@property (weak, nonatomic) IBOutlet UILabel *tagTitle;
    //@property (weak, nonatomic) IBOutlet UILabel *tagUrl;
    //@property (weak, nonatomic) IBOutlet UILabel *tagAddress;
    //@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
    @IBOutlet weak var tagTitle: UILabel!
    @IBOutlet weak var tagUrl: UILabel!
    @IBOutlet weak var tagNumber: UILabel!
    @IBOutlet weak var tagAddress: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}