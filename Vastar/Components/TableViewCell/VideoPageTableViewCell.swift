//
//  VideoPageTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2022/6/6.
//

import UIKit

class VideoPageTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadTextData(title:String) {
        
        self.titleLabel.text = title
        self.titleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
}
