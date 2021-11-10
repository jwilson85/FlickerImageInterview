//
//  ImageDetailsViewController.swift
//  FlickerImages
//
//  Created by Wilson, Jeremy on 11/9/21.
//

import Foundation
import UIKit

struct ImageDetailsViewModel {
    var imageUrl: String
}

class ImageDetailsViewController: UIViewController {
    
    @IBOutlet weak var largeImageVIew: UIImageView!
    
    var viewModel: ImageDetailsViewModel?
    let imageLoader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrlString = viewModel?.imageUrl {
            imageLoader.obtainImageWithPath(imagePath: imageUrlString) { image in
                self.largeImageVIew.image = image
            }
        }
    }
}
