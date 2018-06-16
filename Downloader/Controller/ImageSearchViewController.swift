//
//  ImageSearchViewController.swift
//  Downloader
//
//  Created by Владимир Бондарь on 6/16/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController {

    @IBOutlet weak var downloadedImageView: UIImageView!
    @IBOutlet weak var urlSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlSearchBar.delegate = self
//
//        downloadedImageView.image = #imageLiteral(resourceName: "IMG.PNG")
//
    }
    

    
    
    @IBAction func saveImage(_ sender: UIButton) {
        guard let downloadedImage = downloadedImageView.image else {
            alert(message: "Can't save Image")
            return
        }
        CoreDataHelper.save(imageLink: urlSearchBar.text,
                            imageData: UIImageJPEGRepresentation(downloadedImage, 0))
        alert(message: "Saved!")
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        downloadedImageView.getImage(from: searchBar.text) { self.alert(message: $0) }
        view.endEditing(true)
    }
}
