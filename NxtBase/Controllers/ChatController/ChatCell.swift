//
//  ChatCell.swift
//  NxtBase
//
//  Created by mac on 04/04/2020.
//  Copyright © 2020 Private. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var imgPicture: UIImageView!{
        didSet {
            imgPicture.circularView()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
