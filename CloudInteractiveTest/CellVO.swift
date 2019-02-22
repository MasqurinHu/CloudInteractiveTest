//
//  JsonVO.swift
//  CloudInteractiveTest
//
//  Created by 五加一 on 2019/2/22.
//  Copyright © 2019 五加一. All rights reserved.
//

import Foundation

protocol TestVOSpec {
    var content: String { get }
}

struct ErrorVO: Error, TestVOSpec {
    
    enum ErrorType: String {
        case downloadError,
        noDownloadDataError,
        urlError,
        jsonToVoError
    }
    let error: ErrorType
    let content: String
    
}

struct PhotoBoxVo: TestVOSpec {
    
    let box: [CellVO]
    let content: String
}

struct CellVO: Codable {
    
    enum ImageType {
        case thumbnail,
        original
    }
    
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    func getUrl(with type: ImageType) -> URL? {
        
        let sUrl: String
        
        switch type {
        
        case .thumbnail:
            sUrl = thumbnailUrl
        case .original:
            sUrl = url
        }
        guard let url: URL = URL(string: sUrl) else {
            return nil
        }
        return url
    }
    
    
}
