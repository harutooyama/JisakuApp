//
//  TimeLineCollectionViewCell.swift
//  Jisaku
//
//  Created by Owner on 2020/06/22.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class TimeLineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var postTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
