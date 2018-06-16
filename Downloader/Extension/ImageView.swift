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
                errorMessage("cant create URL")
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errorMessage("request error")
                }
                return
            }
            if let image = UIImage(data: data) {
                self.image = image
            } else {
                DispatchQueue.main.async {
                    errorMessage("no image in this link")
                }
            }
        }.resume()
    }
}
