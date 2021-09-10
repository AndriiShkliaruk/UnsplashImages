//
//  PhotoGalleryViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 08.09.2021.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    var topicData: UnsplashTopic?
    var photos = [UnsplashPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let topic = topicData else { return }
        
        self.title = topic.title
        let layout = PhotoGridUICollectionViewFlowLayout(cellsInRow: 2, spaceBetweenCells: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        self.photosCollectionView = collectionView
        
        loadPhotos(with: topic.id)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        photosCollectionView?.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoURL = photos[indexPath.row].urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photoURL, cellType: .photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photoDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "photoDetailSegue" {
            if let destinationViewController = segue.destination as? PhotoDetailViewController {
                if let indexPath = sender as? IndexPath {
                    destinationViewController.photoData = photos[indexPath.row]
                }
            }
        }
    }
    
    
    fileprivate func loadPhotos(with topicId: String) {
        let url = Endpoint.topicsPhotos(id: topicId).url
        DataLoader.get(from: url) { (result: Result<[UnsplashPhoto], DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let results):
                DispatchQueue.main.async {
                    self.photos = results
                    self.photosCollectionView?.reloadData()
                }
            }
        }
    }
    

}
