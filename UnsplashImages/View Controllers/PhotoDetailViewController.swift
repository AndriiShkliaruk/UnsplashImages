//
//  PhotoDetailViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 08.09.2021.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    var photoData: UnsplashPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topicPhoto = photoData {
            refreshButton.isHidden = true
            loadPhoto(from: topicPhoto.urls.regular)
        } else {
            loadRandomPhoto()
        }
    }
    
    
    func loadPhoto(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.photoImageView.image = image
            
            }
        }.resume()
    }
    
    
    fileprivate func loadRandomPhoto() {
        DataLoader.get(from: Endpoint.randomPhoto().url) { (result: Result<UnsplashPhoto, DataError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let photo):
                
                self.loadPhoto(from: photo.urls.regular)
                
            }
        }
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
           
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        loadRandomPhoto()
    }
    
    @IBAction func savePhotoButtonPressed(_ sender: Any) {
        guard let photo = photoImageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(photo, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    

}
