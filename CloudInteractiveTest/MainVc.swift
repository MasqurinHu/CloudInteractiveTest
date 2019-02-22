//
//  MainVc.swift
//  CloudInteractiveTest
//
//  Created by 五加一 on 2019/2/22.
//  Copyright © 2019 五加一. All rights reserved.
//

import UIKit

class MainVc: UIViewController {
    
    private
    let btn: UIButton = UIButton(type: .system)
    private
    let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setBtn()
        layoutBtn()
        setActivityView()
    }
}

extension MainVc {
    
    private
    func setBtn() {
        
        btn.setTitle("Request Api", for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
    }
    
    private
    func layoutBtn() {
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btn.sizeToFit()
    }
    
    @objc private
    func btnAction(_ btn: UIButton) {
        
        getData()
    }
    private
    func getData() {
        
        activityView.startAnimating()
        DownloadManager.shared.getJsonData(with: .photos) { [weak self] (isError, vo) in
            
            guard let `self` = self else {
                return
            }
            
            defer {
                
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                }
            }
            if let error: Error = isError {
                
                let msg: String
                if let error: ErrorVO = error as? ErrorVO {
                    
                    msg = error.content
                } else {
                    msg = error.localizedDescription
                }
                self.needAlert(with: msg)
                return
            }
            guard let vo: PhotoBoxVo = vo as? PhotoBoxVo else {
                assertionFailure("vo to PhotoBoxVo error")
                return
            }
            let vc: CollectionVc = CollectionVc()
            vc.vo = vo
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    private
    func setActivityView() {
        
        activityView.frame = view.frame
        activityView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        view.addSubview(activityView)
        activityView.hidesWhenStopped = true
    }
    
    private
    func needAlert(with msg: String) {
        
        let alert: UIAlertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let retry: UIAlertAction = UIAlertAction(title: "Retry", style: .default) { [weak self] (_) in
            self?.getData()
        }
        let cancel: UIAlertAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(retry)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
