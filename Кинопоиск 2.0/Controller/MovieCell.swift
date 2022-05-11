//
//  MovieCell.swift
//  MovieCell
//
//  Created by Roman Kiruxin on 08.05.2022.
//

import UIKit

class MovieCell: UITableViewCell {
    
    var foundMovies: Movies?
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var yearOfRelease: UILabel!
    @IBOutlet weak var descriptionOfFilm: UILabel!
    
    func configure() {
        
        nameMovie.text = foundMovies?.name
        
        if let year = foundMovies?.year {
            yearOfRelease.text = String(year)
        } else {
            yearOfRelease.text = "Год выпуска неизвестен"
        }
        
        descriptionOfFilm.text = foundMovies?.description ?? ""
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: self.foundMovies?.poster?.url ?? "") else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }

            DispatchQueue.main.async {
                self.moviePoster.image = UIImage(data: imageData)
            }
        }
        
        
    }

}
