//
//  ItemCell.swift
//  Listr
//
//  Created by Hesham Saleh on 1/29/17.
//  Copyright © 2017 Hesham Saleh. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumbnail.image = item.toImage?.image as? UIImage
    }
}
