//
//  NoteOverviewTableView.swift
//  Notes
//
//  Created by Grochowalski, Fabian on 23.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//

import UIKit

class NoteOverviewTableView: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "paper"))
        backgroundView = imageView;
        allowsSelection = true
    }
}
