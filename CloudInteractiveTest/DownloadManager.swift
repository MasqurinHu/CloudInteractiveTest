//
//  DownloadManager.swift
//  CloudInteractiveTest
//
//  Created by 五加一 on 2019/2/22.
//  Copyright © 2019 五加一. All rights reserved.
//

import Foundation

class DownloadManager {
    
    static
    let shared: DownloadManager = DownloadManager()
    private
    init() {}
    
    private
    let session: URLSession = URLSession(configuration: .default)
    
    @discardableResult
    func getTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        return session.dataTask(with: url, completionHandler: completionHandler)
    }
    
    func getJsonData(with type: EndPoint, doneHandle: @escaping (Error?, TestVOSpec) -> ()) {
        
        guard let url: URL = getUrl(with: type).url else {
            let errorVo: ErrorVO = ErrorVO(error: .urlError, content: getUrl(with: type).string)
            doneHandle(errorVo, errorVo)
            return
        }
        let task = getTask(with: url) { [weak self] (data, response, error) in
            
            if let error: Error = error {
                doneHandle(error, ErrorVO(error: .downloadError, content: error.localizedDescription))
                return
            }
            guard let data: Data = data,
                let sJson: String = String(data: data, encoding: .utf8),
                let `self` = self else {
                    let error: ErrorVO = ErrorVO(error: .noDownloadDataError, content: ErrorVO.ErrorType.noDownloadDataError.rawValue)
                    doneHandle(error, error)
                    return
            }
            
            let vo: TestVOSpec
            switch type {
                
            case .photos:
                guard let photosVo: [CellVO] = try? JSONDecoder().decode([CellVO].self, from: data) else {
                    let error: ErrorVO = ErrorVO(error: .jsonToVoError, content: sJson)
                    doneHandle(error, error)
                    return
                }
                let box: PhotoBoxVo = PhotoBoxVo(box: photosVo, content: self.getUrl(with: type).string)
                vo = box
            }
            doneHandle(nil, vo)
        }
        task.resume()
    }
}

extension DownloadManager {
    
    private
    var sBaseUrl: String { return "https://jsonplaceholder.typicode.com" }
    
    enum EndPoint: String {
        case photos = "/photos"
    }
    
    private
    func getUrl(with type: EndPoint) -> (url: URL?, string: String) {
        
        let sUrl: String = sBaseUrl + type.rawValue
        guard let url: URL = URL(string: sUrl) else {
            return (nil, sUrl)
        }
        return (url, sUrl)
    }
    
}
