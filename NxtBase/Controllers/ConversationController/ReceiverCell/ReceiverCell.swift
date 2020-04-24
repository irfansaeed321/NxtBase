//
//  ReceiverCell.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.roundCorners(radius: 15, bordorColor: .clear, borderWidth: 0.5)
        }
    }
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
