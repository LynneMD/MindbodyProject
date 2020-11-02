//
//  ProvinceCell.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import UIKit

/// Visulizes a province.
class ProvinceCell: UITableViewCell {
    @IBOutlet private weak var provinceLabel: UILabel!
    var province:Province?
    
    func loadUI(){
        self.provinceLabel.text = province?.provinceName
    }
}
