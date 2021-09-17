//
//  SearchPhotosViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 09.09.2021.
//

import UIKit

class SearchPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var photos = [UnsplashPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = PhotoGridUICollectionViewFlowLayout(cellsInRow: 2, spaceBetweenCells: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.photosCollectionView = collectionView
        
        searchBar.delegate = self
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        photosCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + searchBar.frame.size.height, width: view.frame.size.width, height: view.frame.size.height - searchBar.frame.size.height - 83)
        print(self.tabBarController!.tabBar.frame.size.height)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoURL = photos[indexPath.row].urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photoURL, title: nil)
        return cell
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text {
            loadPhotos(with: query)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "searchPhotoDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "searchPhotoDetailSegue" {
            if let destinationViewController = segue.destination as? PhotoDetailViewController {
                if let indexPath = sender as? IndexPath {
                    destinationViewController.photoData = photos[indexPath.row]
                }
            }
        }
    }
    
    fileprivate func loadPhotos(with query: String) {
        let url = Endpoint.searchPhotos(query: query).url
        DataLoader.get(from: url) { (result: Result<SearchResponse, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let result):
                DispatchQueue.main.async {
                    self.photos = result.results
                    self.photosCollectionView?.reloadData()
                }
            }
        }
    }
    

}
