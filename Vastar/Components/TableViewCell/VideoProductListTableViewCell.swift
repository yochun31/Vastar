//
//  VideoProductListTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/10/1.
//

import UIKit
import SDWebImage

class VideoProductListTableViewCell: UITableViewCell {

    @IBOutlet var productTypeLabel: UILabel!
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
    
    func loadData(typeSt:String,titleSt:String,url:URL) {
        
        self.productImageView.sd_setImage(with: url, placeholderImage:nil)
        
        self.productTypeLabel.text = typeSt
        self.productTypeLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.productTitleLabel.text = titleSt
        self.productTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
    func loadData(typeSt:String,titleSt:String,imageSt:String) {
        
        self.productImageView.image = UIImage(named: imageSt)
        self.productTypeLabel.text = typeSt
        self.productTypeLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.productTitleLabel.text = titleSt
        self.productTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
}
