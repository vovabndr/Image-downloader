//
//  ImageSearchViewController.swift
//  Downloader
//
//  Created by Владимир Бондарь on 6/16/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var downloadedImageView: UIImageView!
    @IBOutlet weak var urlSearchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 10.0
            saveButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlSearchBar.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.items![0].title = "Image Downloader"
    }

    @objc func tap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func saveImage(_ sender: UIButton) {
        guard let downloadedImage = downloadedImageView.image else {
            alert(message: "Can't save Image")
            return
        }
        guard let urlString = urlSearchBar.text, URL(string: urlString) != nil else {
            alert(message: "Bad URL")
            return
        }
        CoreDataHelper.save(imageLink: urlSearchBar.text,
                            imageData: UIImageJPEGRepresentation(downloadedImage, 0)) { self.alert(message: $0)}
    }
    
    @IBAction func shareBarButton(_ sender: UIBarButtonItem) {
        guard let image = downloadedImageView.image else {
            alert(message: "No image")
            return
        }
        let imageShare = [image]
        
        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
       
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, arr, error in
            if !completed {
                self.alert(message: "Canceled")
                return
            }
            if activityType == .saveToCameraRoll {
                self.alert(message: "Save To Camera Roll")
                return
            } else if activityType == .copyToPasteboard {
                self.alert(message: "Copied")
                return
            }
        }
    }
    
    fileprivate func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            alertController.dismiss(animated: true, completion: nil)
            self.view.endEditing(true)
        }
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if CoreDataHelper.check(imageLink: searchBar.text) {
                    downloadedImageView.getImage(from: searchBar.text) { self.alert(message: $0) }
        } else {
            alert(message: "Previously downloaded")
            CoreDataHelper.fetch {
                self.downloadedImageView.image = UIImage(data: ($1.first {$0.link == searchBar.text}?.image)!)
            }
        }
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)! {
            downloadedImageView.image = nil
        }
    }
}
