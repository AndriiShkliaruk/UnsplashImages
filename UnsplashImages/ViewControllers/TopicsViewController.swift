//
//  TopicsViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 06.09.2021.
//

import UIKit

class TopicsViewController: UIViewController, UICollectionViewDataSource {
        
    private var collectionView: UICollectionView?
    var topics = [UnsplashTopic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.collectionView = collectionView
        
        loadTopics()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let coverPhotoURL = topics[indexPath.row].coverPhoto.urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: coverPhotoURL)
        return cell
    }
    
    fileprivate func loadTopics() {
        let url = Endpoint.topics(itemsPerPage: 20).url
        DataLoader.get(from: url) { (result: Result<[UnsplashTopic], DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                DispatchQueue.main.async {
                    self.topics = results
                    self.collectionView?.reloadData()
                }
            }
        }
    }

}
