//
//  Buttons.swift
//  Notes
//
//  Created by Grochowalski, Fabian on 23.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//

import UIKit

class Buttons: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.black, for: .normal)
        setTitleColor(UIColor.blue, for: .selected)
    }

}
