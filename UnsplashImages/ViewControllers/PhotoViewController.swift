//
//  PhotoViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 08.09.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photoData: UnsplashPhoto?
    
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
        
        
        if let photo = photoData {
            load(photo: photo)
        } else {
            loadRandomPhoto()
            navigationItem.leftBarButtonItem = refreshBarButtonItem
        }
        
        setupView()
        setupImageView()
    }
    
    
    
    //MARK: - Setup UI Elements
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupImageView() {
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
    
    private func load(photo: UnsplashPhoto) {
        let url = photo.urls.regular
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
                self?.navigationItem.title = "Photo by \(photo.user.name)"
            }
        }.resume()
    }
    
    @objc private func loadRandomPhoto() {
        let url = Endpoint.randomPhoto.url
        DataLoader.get(from: url) { (result: Result<UnsplashPhoto, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let photo):
                
                self.load(photo: photo)
            }
        }
    }
    

    

}
