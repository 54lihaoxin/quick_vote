//
//  QuickVoteServiceIO.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/22/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

final class QuickVoteServiceIO: NSObject {
    
    fileprivate let service: NetService
    fileprivate var inputStream: InputStream?
    fileprivate var outputStream: OutputStream?
    
    init(service: NetService) {
        self.service = service
    }
    
    deinit {
        closeSteams()
    }
}

// MARK: - API

extension QuickVoteServiceIO {
    
    @discardableResult func start() -> Bool {
        var inputStream: InputStream?
        var outputStream: OutputStream?
        
        guard
            service.getInputStream(&inputStream, outputStream: &outputStream),
            let input = inputStream,
            let output = outputStream else {
            return false
        }
        self.inputStream = input
        self.outputStream = output
        openStreams()
        return true
    }
}

// MARK: - NSStreamDelegate

extension QuickVoteServiceIO: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("\(#function) .openCompleted")
        case .hasBytesAvailable:
            print("\(#function) .hasBytesAvailable")
        case .hasSpaceAvailable:
            print("\(#function) .hasSpaceAvailable")
        case .errorOccurred:
            print("\(#function) .errorOccurred")
        case .endEncountered:
            print("\(#function) .endEncountered")
        default:
            assertionFailure("\(#function) unhandled event code \(eventCode)")
        }
    }
}

// MARK: - private helpers

private extension QuickVoteServiceIO {
    
    func openStreams() {
        guard let inputStream = inputStream, let outputStream = outputStream else {
            assertionFailure("\(#function) `inputStream` and/or `outputStream` is nil")
            return
        }
        inputStream.delegate = self
        outputStream.delegate = self
        inputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream.open()
        outputStream.open()
    }
    
    func closeSteams() {
        inputStream?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream?.close()
        outputStream?.close()
    }
}
