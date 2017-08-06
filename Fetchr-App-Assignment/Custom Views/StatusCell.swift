//
//  StatusCell.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/5/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }

}
