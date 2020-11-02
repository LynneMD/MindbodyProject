//
//  CountryCell.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import UIKit

/// Visulizes a country.
class CountryCell: UITableViewCell {
    @IBOutlet private weak var flagImage: UIImageView!
    @IBOutlet private weak var countryLabel: UILabel!
    var country:Country?{
        didSet{
            self.country?.flagDidLoad = { [weak self] img in
                self?.flagImage.image = UIImage(data: img)
            }
            self.country?.fetchFlag()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        country?.flagDidLoad = nil
    }
    
    func loadUI(){
        self.countryLabel.text = country?.name
        // Use image if it exists in local cache.
        guard let flag = country?.flag else{
            return
        }
        self.flagImage.image = UIImage(data: flag)
    }
}
