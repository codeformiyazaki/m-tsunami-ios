//
//  PhotoTableViewCell.swift
//  06-earthquake
//
//  Created by koogawa on 2020/01/05.
//  Copyright © 2020 LmLab.net. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
