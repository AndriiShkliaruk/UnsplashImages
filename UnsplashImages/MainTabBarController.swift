//
//  MainTabBarController.swift
//  UnsplashImages
//
//  Created by Andrii Shkliaruk on 15.09.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        let photoViewController = PhotoViewController()
        let topicsCollectionViewController = TopicsCollectionViewController(collectionViewLayout: TopicsGridLayout(cellsInRow: 2, spaceBetweenCells: 10))
        let searchCollectionViewController = SearchCollectionViewController(collectionViewLayout: GalleryLayout())
        
        viewControllers = [
            generateNavigationController(rootViewController: photoViewController, title: "Random Photo", image: #imageLiteral(resourceName: "die.face.3")),
            generateNavigationController(rootViewController: topicsCollectionViewController, title: "Topics", image: #imageLiteral(resourceName: "square.3.stack.3d.top.fill")),
            generateNavigationController(rootViewController: searchCollectionViewController, title: "Search", image: #imageLiteral(resourceName: "magnifyingglass"))
        ]
        
        
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        navigationViewController.tabBarItem.title = title
        navigationViewController.tabBarItem.image = image
        return navigationViewController
    }
    

}
