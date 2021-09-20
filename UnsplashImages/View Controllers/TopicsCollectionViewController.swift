//
//  TopicsCollectionViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 15.09.2021.
//

import UIKit

class TopicsCollectionViewController: UICollectionViewController {

    private var topics = [UnsplashTopic]()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupSpinner()
        loadTopics()
    }
    
    
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.title = "Topics"
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.clipsToBounds = true
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    

    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell else {
            return UICollectionViewCell()
        }
        
        cell.unsplashPhoto = topics[indexPath.row].coverPhoto
        cell.title = topics[indexPath.row].title
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToPhotos(from: topics[indexPath.row])
    }
    

    
    // MARK: - Navigation

    private func navigateToPhotos(from topic: UnsplashTopic) {
        let galleryLayout = GalleryLayout()
        let galleryViewController = GalleryCollectionViewController(collectionViewLayout: galleryLayout)
        galleryLayout.delegate = galleryViewController
        galleryViewController.topicData = topic
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    
    
    //MARK: - Networking
    
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
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    

}
