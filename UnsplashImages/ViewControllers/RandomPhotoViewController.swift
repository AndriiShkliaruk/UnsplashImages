//
//  RandomPhotoViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 06.09.2021.
//

import UIKit

class RandomPhotoViewController: UIViewController {
    @IBOutlet weak var randomPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewPhoto()
    }
    

    @IBAction func refreshPhotoButtonPressed(_ sender: Any) {
        loadNewPhoto()
    }
    
    
    fileprivate func loadNewPhoto() {
        DataLoader.get(from: Endpoint.randomPhoto().url) { (result: Result<UnsplashPhoto, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let photo):
                guard let url = URL(string: photo.urls.regular) else {
                    return
                }
                URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.randomPhoto.image = image
                    }
                }.resume()
            }
        }
    }
}
