//
//  CollectionViewCell.swift
//  Multi-image-Picker
//
//  Created by Md. Faysal Ahmed on 21/10/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(image: UIImage) {
        img.image = image
    }


}
