//
//  VideoListTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/9/27.
//

import UIKit
import SDWebImage

class VideoListTableViewCell: UITableViewCell {

    @IBOutlet var videoImage: UIImageView!
    @IBOutlet var seriesTitleLabel: UILabel!
    @IBOutlet var nameTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(title1St:String,title2St:String,url:URL) {
        
        self.videoImage.sd_setImage(with: url, placeholderImage:nil)
        
        self.seriesTitleLabel.text = title1St
        self.seriesTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.nameTitleLabel.text = title2St
        self.nameTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        

        
    }
    
}
