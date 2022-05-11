//
//  TopMovieCell.swift
//  TopMovieCell
//
//  Created by Roman Kiruxin on 08.05.2022.
//

import UIKit

class TopMovieCell: UICollectionViewCell {
    
    var topMovie: Movies?
    
    @IBOutlet weak var imagePoster: UIImageView!
    
    func configure() {
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: self.topMovie?.poster?.url ?? "") else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }

            DispatchQueue.main.async {
                self.imagePoster.image = UIImage(data: imageData)
            }
        }
    }
}
