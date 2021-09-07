//
//  ViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 30.08.2021.
//

import UIKit



class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var collectionView: UICollectionView?
    var results = [UnsplashPhoto]()
    let searchbar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        view.addSubview(searchbar)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        

//        let url = Endpoint.topics(itemsPerPage: 4).url
//        DataLoader.get(from: url) { (result: Result<[UnsplashImage], DataError>) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let topics):
//                DispatchQueue.main.async {
//                    self.results = topics
//                    self.collectionView?.reloadData()
//                }
//            }
//        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width - 20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.frame.size.width, height: view.frame.size.height - 55)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchbar.text {
            results = []
            DataLoader.get(from: Endpoint.searchPhotos(query: text, itemsPerPage: 50).url) { (result: Result<SearchResponse, DataError>) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let images):
                    DispatchQueue.main.async {
                        self.results = images.results
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coverPhotoURL = results[indexPath.row].urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
       // cell.configure(with: coverPhotoURL)
        return cell
    }

}

