//
//  AccountCell.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var logo: UIWebView!
    @IBOutlet weak var displayName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func install(_ account:Account?) {
        self.logo.loadRequest(URLRequest(url: URL(string: (account?.provider?.logoURI)!)!))
        self.displayName.text = account?.displayName
    }
}
