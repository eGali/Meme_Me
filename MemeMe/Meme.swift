//
//  meme.swift
//  MemeMe
//
//  Created by Edgar on 7/12/16.
//  Copyright © 2016 Edgar. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
    
    // Constructor
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}