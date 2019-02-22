//
//  UrlImgView.swift
//  CloudInteractiveTest
//
//  Created by 五加一 on 2019/2/22.
//  Copyright © 2019 五加一. All rights reserved.
//

import UIKit

class UrlImgView: UIImageView {
    
    func getImg(with url: URL) {
        
        if isFirstSet {
            setLoadImg()
            isFirstSet = false
        }
        image = nil
        if let task: URLSessionTask = task {
            task.cancel()
        }
        task = nil
        loadview.startAnimating()
        task = DownloadManager.shared.getTask(with: url){ [weak self] (data, response, error) in
            
            guard let `self` = self,
                let data: Data = data else {
                    return
            }
            DispatchQueue.main.async {
                self.loadview.stopAnimating()
            }
            let img: UIImage? = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = img
            }
        }
        task?.resume()
    }
    
    private
    let loadview: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private
    var task: URLSessionTask?
    private
    var isFirstSet: Bool = true
}

extension UrlImgView {
    
    private
    func setLoadImg() {
        
        loadview.translatesAutoresizingMaskIntoConstraints = false
        loadview.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        loadview.hidesWhenStopped = true
        addSubview(loadview)
        loadview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadview.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        loadview.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
