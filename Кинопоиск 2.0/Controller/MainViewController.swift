//
//  MainViewController.swift
//  MainViewController
//
//  Created by Roman Kiruxin on 08.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    var topMovies: SearchMovies?
    var foundMovies: SearchMovies?
    
    var jsonSearch = JSONUrl.shared.jsonUrlSeachingMovies
    
    var search = ""
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTF.delegate = self
        
        NetworkManager.fetchDataMovies(jsonUrl: JSONUrl.shared.jsonUrlTopMovies, page: 1) { topMovies in
            self.topMovies = topMovies
            self.collectionview.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topFilms" {
            guard let detailVC = segue.destination as? DetailsViewController else { return }
            guard let cell = sender as? TopMovieCell else { return }
            
            detailVC.searchingMovies = cell.topMovie
            detailVC.poster = cell.imagePoster.image
        } else if segue.identifier == "searchFilm" {
            guard let detailVC = segue.destination as? DetailsViewController else { return }
            guard let cell = sender as? MovieCell else { return }
            
            detailVC.searchingMovies = cell.foundMovies
            detailVC.poster = cell.moviePoster.image
        }
    }
    
    @IBAction func searchMovie(_ sender: Any) {
        
        if searchTF.text?.isEmpty ?? true {
            
            view.endEditing(true)
            foundMovies = nil
            self.tableview.reloadData()
            
            let message = "Поле пустое! Введите данные для поиска"
            
            showAlert(message: message)
            
        } else {
            searchAction()
        }
    }
    
    private func showAlert(message: String) {
        let alertError = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertError.addAction(cancel)
        present(alertError, animated: true, completion: nil)
    }
    
    private func searchAction() {

        view.endEditing(true)
        
        search = searchTF.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        NetworkManager.fetchDataMovies(jsonUrl: jsonSearch + search, page: 1) { foundMovies in
        
            self.foundMovies = foundMovies
            
            if (self.foundMovies?.total != 0) {
                self.tableview.reloadData()
            } else {
                let message = "Ничего не найдено!!! Попробуйте еще раз"
                self.showAlert(message: message)
                self.searchTF.text = nil
            }
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topMovies?.docs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topMovie", for: indexPath) as! TopMovieCell
        
        cell.topMovie = topMovies?.docs[indexPath.item]
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchTF.resignFirstResponder()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundMovies?.docs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieCell
        
        cell.foundMovies = foundMovies?.docs[indexPath.item]
        cell.configure()
        
        guard let totalPages = foundMovies?.pages else { return cell }
        guard var page = foundMovies?.page else { return cell }
        guard let docs = foundMovies?.docs else { return cell }

        if (indexPath.row == (docs.count - 1)) {
            if page != totalPages {
                page += 1
                
                NetworkManager.fetchDataMovies(jsonUrl: jsonSearch + search, page: page) { foundMovies in
                    if foundMovies.total != 0 {
                        self.foundMovies?.docs += foundMovies.docs
                        self.foundMovies?.page = foundMovies.page
                        tableView.reloadData()
                    }
                }
            } else {
                return cell
            }
        } else {
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchTF.resignFirstResponder()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
