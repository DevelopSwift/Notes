//
//  IndicatorDropDownDataset.swift
//  Notes
//
//  Created by Grochowalski, Fabian on 22.03.18.
//  Copyright © 2018 Fabian Grochowalski. All rights reserved.
//

import Foundation
class IndicatorDropDownDataset{
    var _indicator: [String] = [NSLocalizedString("warning", comment: ""), NSLocalizedString("alert", comment: ""), NSLocalizedString("info", comment: "")]
    
    var indicator: [String] {
        get {
            return _indicator
        }
    }
}
