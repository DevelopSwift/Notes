//
//  NoteControllerTableViewCell.swift
//  Notes
//
//  Created by Fabian Grochowalski on 09.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//

import UIKit

class NoteControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var NoteTitleLabel: UILabel!
    @IBOutlet weak var NoteIndicatorImageView: UIImageView!
    @IBOutlet weak var NoteIndicatorLabel: UILabel!
    @IBOutlet weak var NoteSubTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
