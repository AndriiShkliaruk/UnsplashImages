//
//  PhotoViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 08.09.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photoData: UnsplashPhoto?
    private var savedPhotos = [UIImage]()
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadRandomPhoto))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButtonTapped))
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let photo = photoData {
            load(photo: photo)
        } else {
            loadRandomPhoto()
            navigationItem.leftBarButtonItem = refreshBarButtonItem
        }
        
        setupNavigationBar()
        setupImageView()
        setupSpinner()
    }
    
    
    
    //MARK: - Setup UI Elements
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = actionBarButtonItem
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    
    
    // MARK: - Navigation items action
    
    @objc private func shareBarButtonTapped(sender: UIBarButtonItem) {
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: savedPhotos, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.savedPhotos.removeAll()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Data loading
    
    private func load(photo: UnsplashPhoto) {
        let url = photo.urls.full
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.imageView.image = image
                    self?.savedPhotos.append(image)
                    self?.navigationItem.title = "Photo by \(photo.user.name)"
                    self?.spinner.stopAnimating()
                }
            }
        }.resume()
    }
    
    @objc private func loadRandomPhoto() {
        savedPhotos.removeAll()
        spinner.startAnimating()
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
