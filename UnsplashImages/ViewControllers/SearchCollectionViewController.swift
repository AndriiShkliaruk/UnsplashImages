//
//  SearchCollectionViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 19.09.2021.
//

import UIKit


class SearchCollectionViewController: UICollectionViewController, GalleryLayoutDelegate, UISearchBarDelegate {
    
    private var timer: Timer?
    private var photos = [UnsplashPhoto]()
    
    private let enterLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
        setupEnterLabel()
        setupSpinner()
        
    }
    
    //MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        if let galleryLayout = collectionViewLayout as? GalleryLayout {
            galleryLayout.delegate = self
        }
    }
    
    private func setupEnterLabel() {
        collectionView.addSubview(enterLabel)
        enterLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Search"
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    
    
    // MARK: - UICollecionViewDataSource, UICollecionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterLabel.isHidden = photos.count != 0
        return photos.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.unsplashPhoto = photos[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateTo(photo: photos[indexPath.row])
    }
    
    
    
    // MARK: - GalleryLayoutDelegate
    
    func galleryLayout(_ layout: GalleryLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        return CGSize(width: photo.width, height: photo.height)
    }
    
    
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.spinner.startAnimating()
            timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { (_) in
                self.loadPhotosBy(query: searchText)
                print(searchText)
            })
        }
    
    
    
    // MARK: - Navigation

    private func navigateTo(photo: UnsplashPhoto) {
        let photoViewController = PhotoViewController()
        photoViewController.photoData = photo
        navigationController?.pushViewController(photoViewController, animated: true)
    }
    
    
    // MARK: - Networking
    
    private func loadPhotosBy(query: String) {
        let url = Endpoint.searchPhotos(query: query).url
        DataLoader.get(from: url) { (result: Result<SearchResponse, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.photos = searchResults.results
                    self.spinner.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    
}
