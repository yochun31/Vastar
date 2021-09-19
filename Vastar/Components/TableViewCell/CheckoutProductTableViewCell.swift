//
//  CheckoutProductTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/2.
//

import UIKit

class CheckoutProductTableViewCell: UITableViewCell {

    @IBOutlet var productPhoto: UIImageView!
    @IBOutlet var productContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(titleST:String,photo:UIImage) {
        
        self.productContentLabel.text = titleST
        self.productContentLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.productPhoto.image = photo
        
    }
    
    func loadData(titleSt:String,url:URL) {
        
        self.productPhoto.sd_setImage(with: url, placeholderImage:nil)
        
        self.productContentLabel.text = titleSt
        self.productContentLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
    }
}
