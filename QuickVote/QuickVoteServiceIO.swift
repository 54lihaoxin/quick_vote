//
//  QuickVoteServiceIO.swift
//  QuickVote
//
//  Created by Haoxin Li on 7/23/18.
//  Copyright © 2018 Haoxin Li. All rights reserved.
//

import Foundation

final class QuickVoteServiceIO: NSObject {
    
    let inputStream: InputStream
    let outputStream: OutputStream
    
    init(inputStream: InputStream, outputStream: OutputStream) {
        self.inputStream = inputStream
        self.outputStream = outputStream
        super.init()
        inputStream.delegate = self
        outputStream.delegate = self
    }
}

// MARK: - API

extension QuickVoteServiceIO {
    
    func openStreams() {
        inputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream.open()
        outputStream.open()
    }
    
    func closeSteams() {
        inputStream.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream.close()
        outputStream.close()
    }
}


// MARK: - NSStreamDelegate

extension QuickVoteServiceIO: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        let streamID = aStream == inputStream ? "`inputStream`" : (aStream == outputStream ? "`outputStream`" : "unknown stream")
        switch eventCode {
        case .openCompleted:
            print("\(type(of: self)).\(#function) \(streamID) .openCompleted")
        case .hasBytesAvailable:
            print("\(type(of: self)).\(#function) \(streamID) .hasBytesAvailable")
        case .hasSpaceAvailable:
            print("\(type(of: self)).\(#function) \(streamID) .hasSpaceAvailable")
        case .errorOccurred:
            print("\(type(of: self)).\(#function) \(streamID) .errorOccurred")
        case .endEncountered:
            print("\(type(of: self)).\(#function) \(streamID) .endEncountered")
        default:
            assertionFailure("\(type(of: self)).\(#function) \(streamID) unhandled event code \(eventCode)")
        }
    }
}
