//
//  ProductListTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/15.
//

import UIKit
import SDWebImage

class ProductListTableViewCell: UITableViewCell {
    
    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(titleSt:String,url:URL) {
        
        self.productImageView.sd_setImage(with: url, placeholderImage:nil)
        
        self.productTitleLabel.text = titleSt
        self.productTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
    }
    
}
