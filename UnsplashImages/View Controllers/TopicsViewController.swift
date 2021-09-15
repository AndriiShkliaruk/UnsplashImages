//
//  TopicsViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 06.09.2021.
//

import UIKit

class TopicsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    @IBOutlet weak var topicsCollectionView: UICollectionView!
    
    var topics = [UnsplashTopic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = PhotoGridUICollectionViewFlowLayout(cellsInRow: 2, spaceBetweenCells: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.topicsCollectionView = collectionView
        
        loadTopics()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topicsCollectionView?.frame = view.bounds
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
        
        cell.configure(with: coverPhotoURL, title: title, cellType: .topic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "topicsPhotosSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "topicsPhotosSegue" {
            if let destinationViewController = segue.destination as? PhotoGalleryViewController {
                if let indexPath = sender as? IndexPath {
                    destinationViewController.topicData = topics[indexPath.row]
                }
            }
        }
    }
    
    
    func loadTopics() {
        let url = Endpoint.topics.url
        DataLoader.get(from: url) { (result: Result<[UnsplashTopic], DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                DispatchQueue.main.async {
                    self.topics = results
                    self.topicsCollectionView?.reloadData()
                }
            }
        }
    }

}
