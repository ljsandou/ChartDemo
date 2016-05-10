//
//  UserListTableViewCell.swift
//  ChartDemo
//
//  Created by 三斗 on 5/9/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nicknameLabel: UILabel!
  
  @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
