//
//  GalleryCollectionViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 17.09.2021.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController, GalleryLayoutDelegate {
    
    var topicData: UnsplashTopic?
    private var photos = [UnsplashPhoto]()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let topic = topicData else { return }
        
        setupNavigationBar()
        setupCollectionView()
        setupSpinner()
        loadPhotos(by: topic.id)
    }
    
    
    
    // MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        guard let topic = topicData else { return }
        navigationItem.title = topic.title
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    
    
    // MARK: - Navigation
    
    private func navigateTo(photo: UnsplashPhoto) {
        let photoViewController = PhotoViewController()
        photoViewController.photoData = photo
        navigationController?.pushViewController(photoViewController, animated: true)
    }
    
    
    
    // MARK: - Networking
    
    fileprivate func loadPhotos(by topicId: String) {
        let url = Endpoint.topicPhotos(id: topicId).url
        DataLoader.get(from: url) { (result: Result<[UnsplashPhoto], DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                DispatchQueue.main.async {
                    self.photos = results
                    self.collectionView.reloadData()
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
}
