import UIKit

final class CartFooterCell: UIView {

    // MARK: Properties

    @IBOutlet weak var totalItemsLabel: UILabel!

    @IBOutlet weak var totalPriceLabel: UILabel!

    @IBOutlet weak var payButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        //payButton.layer.masksToBounds = false
        //payButton.layer.cornerRadius = 6
        
        payButton.backgroundColor = mainColor
        payButton.tintColor = textColor
        payButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        payButton.layer.cornerRadius = payButton.frame.height/2
        payButton.layer.masksToBounds = true
        payButton.clipsToBounds = true

//ROMEE6
        
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

        //self.contentView.drawTopBorderWithColor(color: UIColor.brown, height: 0.5)
    }
    
}


extension UIView {
    // Draw a border at the top of a view.
    func drawTopBorderWithColor(color: UIColor, height: CGFloat) {
        let topBorder = CALayer()
        topBorder.backgroundColor = color.cgColor
        topBorder.frame = CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: height))
        self.layer.addSublayer(topBorder)
    }
}

