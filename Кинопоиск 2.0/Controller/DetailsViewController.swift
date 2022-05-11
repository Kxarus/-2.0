//
//  ViewController.swift
//  Кинопоиск 2.0
//
//  Created by Roman Kiruxin on 08.05.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var searchingMovies: Movies?
    var poster: UIImage?
    
    @IBOutlet weak var posterMovie: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionMovie: UITextView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        posterMovie.image = poster
        name.text = searchingMovies?.name

        if let descriptionFilm = searchingMovies?.description {
            descriptionMovie.text = "Описание: \(descriptionFilm)"
        } else {
            descriptionMovie.text = "Описание: описание отсутствует..."
        }
        
        if let yearOfRelease = searchingMovies?.year {
            year.text = "Год выпуска: \(String(yearOfRelease))"
        } else {
            year.text = "Год выпуска: неизвестно"
        }
        
        if let ratingOfTheFilm = searchingMovies?.rating?.imdb {
            rating.text = "Рейтинг: \(String(ratingOfTheFilm))"
        } else {
            rating.text = "Рейтинг: нет оценок"
        }
    }
}

