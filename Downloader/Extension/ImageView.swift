//
//  ImageView.swift
//  Downloader
//
//  Created by Владимир Бондарь on 6/16/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImage(from urlString: String?, errorMessage: @escaping (String) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                errorMessage("Can't create URL")
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errorMessage("This link does not exist")
                }
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage("No image on this link")
                }
            }
        }.resume()
    }
}
