//
//  RandomPhotoViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 06.09.2021.
//

import UIKit

class RandomPhotoViewController: UIViewController {
//    @IBOutlet weak var randomPhoto: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadNewPhoto()
//    }
//
//
//    @IBAction func refreshPhotoButtonPressed(_ sender: Any) {
//        loadNewPhoto()
//    }
//
//
//    fileprivate func loadNewPhoto() {
//        let url = Endpoint.randomPhoto.url
//        DataLoader.get(from: url) { (result: Result<UnsplashPhoto, DataError>) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let photo):
//                URLSession.shared.dataTask(with: photo.urls.regular) { [weak self] data, _, error in
//                    guard let data = data, error == nil else {
//                        return
//                    }
//
//                    DispatchQueue.main.async {
//                        let image = UIImage(data: data)
//                        self?.randomPhoto.image = image
//
//                    }
//                }.resume()
//            }
//        }
//    }
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadRandomPhoto))
    }()
    
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationBar()
        setupPhotoView()
        loadRandomPhoto()
        
    }
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.title = "Random Photo"
        navigationItem.leftBarButtonItem = refreshBarButtonItem
    }
    
    private func setupPhotoView() {
        view.addSubview(imageView)
//        imageView.frame = view.bounds
//        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true

    }
    
    //MARK: - Data loading
    
    @objc private func loadRandomPhoto() {
        DataLoader.get(from: Endpoint.randomPhoto.url) { (result: Result<UnsplashPhoto, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let photo):
                URLSession.shared.dataTask(with: photo.urls.regular) { [weak self] data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }

                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.imageView.image = image
                        // TODO: Try to set background color from photo color param
                    }
                }.resume()
            }
        }
    }
    

}
