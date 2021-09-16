//
//  TopicsCollectionViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 15.09.2021.
//

import UIKit

class TopicsCollectionViewController: UICollectionViewController {

    private var topics = [UnsplashTopic]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        loadTopics()
    }
    
    
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.title = "Topics"
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    

    
    // MARK: - Navigation

    private func navigateToPhotos(from topic: UnsplashTopic) {
        let photosViewController = PhotoGalleryViewController()
        photosViewController.topicData = topic
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    

    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coverPhotoURL = topics[indexPath.row].coverPhoto.urls.small
        let title = topics[indexPath.row].title
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: coverPhotoURL, title: title, cellType: .topic)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToPhotos(from: topics[indexPath.row])
    }

    
    //MARK: - Data loading
    
    func loadTopics() {
        let url = Endpoint.topics.url
        DataLoader.get(from: url) { (result: Result<[UnsplashTopic], DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                DispatchQueue.main.async {
                    self.topics = results
                    self.collectionView.reloadData()
                }
            }
        }
    }

}
