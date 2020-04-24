//
//  SenderCell.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.roundCorners(radius: 15, bordorColor: .clear, borderWidth: 0.5)
        }
    }
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
