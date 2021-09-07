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
        
        let spacing: CGFloat = 10
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 15, height: view.frame.size.width / 2 - 15)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
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
        let title = topics[indexPath.row].title
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: coverPhotoURL, title: title)
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
