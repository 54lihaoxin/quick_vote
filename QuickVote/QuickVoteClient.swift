//
//  QuickVoteClient.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

final class QuickVoteClient: NSObject {
    
    fileprivate let hostService: NetService
    fileprivate var serviceIO: QuickVoteServiceIO?
    
    init(host: NetService) {
        hostService = host
    }
    
    deinit {
        serviceIO?.closeSteams()
    }
}

// MARK: - API

extension QuickVoteClient {
    
    @discardableResult func start() -> Bool {
        var input: InputStream?
        var output: OutputStream?
        
        guard
            hostService.getInputStream(&input, outputStream: &output),
            let inputStream = input,
            let outputStream = output else {
            return false
        }
        
        let serviceIO = QuickVoteServiceIO(inputStream: inputStream, outputStream: outputStream)
        self.serviceIO = serviceIO
        serviceIO.openStreams()
        
        return true
    }
}
