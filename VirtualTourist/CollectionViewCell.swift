//
//  CollectionViewCell.swift
//  VirtualTourist
//
//  Created by Abdulkrum Alatubu on 13/12/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
      var url: URL? {
            didSet{
                image.kf.setImage(with: url)
            }
        }
}
