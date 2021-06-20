//
//  ProductListTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/15.
//

import UIKit

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
    
    func loadData(productImage:UIImage,titleSt:String) {
        
        self.productImageView.image = productImage
        self.productTitleLabel.text = titleSt
        self.productTitleLabel.textColor = UIColor.init(red: 235.0/255.0, green: 242.0/255.0, blue: 184.0/255.0, alpha: 1.0)
        
    }
    
}
