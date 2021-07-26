//
//  OrderListTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/7/9.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    
    @IBOutlet var orderNumTitleLabel: UILabel!
    @IBOutlet var orderNumValueBtn: UIButton!
    
    @IBOutlet var orderScheduleTitleLabel: UILabel!
    @IBOutlet var orderScheduleValueBtn: UIButton!
    
    @IBOutlet var freightTilteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(orderNumSt:String,scheduleSt:String) {
        
        self.orderNumTitleLabel.text = NSLocalizedString("Order_Number_title", comment: "")
        self.orderNumTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.orderNumValueBtn.setTitle(orderNumSt, for: .normal)
        self.orderNumValueBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        
        self.orderScheduleTitleLabel.text = NSLocalizedString("Order_Schedule_title", comment: "")
        self.orderScheduleTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        
        self.orderScheduleValueBtn.setTitle(scheduleSt, for: .normal)
        self.orderScheduleValueBtn.setTitleColor(UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0), for: .normal)
        
        self.freightTilteLabel.text = NSLocalizedString("Order_Freight_title", comment: "")
        self.freightTilteLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
}
