//
//  GalleryCollectionViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 17.09.2021.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController {
    
    public var topicData: UnsplashTopic?
    private var photos = [UnsplashPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let topic = topicData else { return }
        
        setupNavigationBar()
        setupCollectionView()
        loadPhotos(by: topic.id)
    }
    
    
    
    // MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        guard let topic = topicData else { return }
        navigationItem.title = topic.title
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    

    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoURL = photos[indexPath.row].urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photoURL, title: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateTo(photo: photos[indexPath.row])
    }
    
    // MARK: - WaterfallLayoutDelegate
    
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        print("HHHHHHHHHHHH")
        return CGSize(width: photo.width, height: photo.height)
    }
    
    

    // MARK: - Navigation

    private func navigateTo(photo: UnsplashPhoto) {
        let photoDetailViewController = PhotoDetailViewController()
        photoDetailViewController.photoData = photo
        navigationController?.pushViewController(photoDetailViewController, animated: true)
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
                }
            }
        }
    }

}
