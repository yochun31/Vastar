//
//  ReceiverTableViewCell.swift
//  Vastar
//
//  Created by 郭堯彰 on 2021/6/11.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    
    @IBOutlet var R_NameLabel: UILabel!
    @IBOutlet var R_PhoneLabel: UILabel!
    @IBOutlet var R_AddressTitleLabel: UILabel!
    @IBOutlet var R_AddressLabel: UILabel!
    
    @IBOutlet var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(nameSt:String,phoneSt:String,addressSt:String) {
        
        self.R_NameLabel.text = "\(NSLocalizedString("Member_Recipient_Name_title", comment: "")): \(nameSt)"
        self.R_PhoneLabel.text = "\(NSLocalizedString("Member_Recipient_Phone_title", comment: "")): \(phoneSt)"
        self.R_AddressTitleLabel.text = "\(NSLocalizedString("Member_Recipient_Adress_title", comment: "")):"
        self.R_AddressLabel.text = addressSt
        
        self.R_NameLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.R_PhoneLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.R_AddressTitleLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        self.R_AddressLabel.textColor = UIColor.init(red: 247.0/255.0, green: 248.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
}
