//
//  ViewController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 30.08.2021.
//

import UIKit

struct APIResponse: Codable {
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let full: String
}

class ViewController: UIViewController {
    
    let urlString = "https://api.unsplash.com/photos?per_page=30&client_id=-UBKtf-Pb9qNmEJR0mxnJsiR5NuAiMMyyKBnbkTlD6s"
    
    var results: [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(url: urlString)
    }
    
    
    func loadData(url: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResult = try JSONDecoder().decode([Result].self, from: data)
                self?.results = jsonResult
                print(jsonResult.count)
            }
            catch {
                print("ERROR - - - \(error)")
            }
        }
        
        task.resume()
    }

}

