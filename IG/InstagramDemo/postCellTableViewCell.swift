//
//  postCellTableViewCell.swift
//  InstagramDemo
//
//  Created by Enzo Ames on 3/13/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class postCellTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var photoImage: PFImageView!
   
    @IBOutlet weak var captionLabel: UILabel!
    
    var instagramPost: PFObject! {
        didSet {
            self.photoImage.file = instagramPost["media"] as? PFFile
            self.photoImage.loadInBackground()
            self.captionLabel.text = instagramPost["caption"] as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
