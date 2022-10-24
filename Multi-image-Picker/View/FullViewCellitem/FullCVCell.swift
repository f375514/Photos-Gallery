//
//  FullCVCell.swift
//  Multi-image-Picker
//
//  Created by Md. Faysal Ahmed on 24/10/22.
//

import UIKit

class FullCVCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.scrollView.delegate = self     //call scrollView
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {  //func for zooming
        
        return self.img
    }
    
}
