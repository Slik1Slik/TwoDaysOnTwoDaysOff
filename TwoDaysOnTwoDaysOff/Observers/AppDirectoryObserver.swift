//
//  AppDirectoryObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 20.04.2022.
//

import SwiftUI

class AppDirectoryObserver: ObservableObject {
    
    let url: URL
    
    var onDirectoryDidChange: (() -> Void)?
    
    private var observedFolderFileDescriptor: CInt = -1
    
    private let directoryObserverQueue = DispatchQueue(label: "FolderObserverQueue", attributes: .concurrent)
    
    private var directoryObserverSource: DispatchSourceFileSystemObject?
    
    init(url: URL) {
        self.url = url
    }
    
    func startObserving() {
        guard directoryObserverSource == nil && observedFolderFileDescriptor == -1 else {
            return
            
        }
        
        observedFolderFileDescriptor = open(url.path, O_EVTONLY)
        
        directoryObserverSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: observedFolderFileDescriptor, eventMask: .all, queue: directoryObserverQueue)
        
        directoryObserverSource?.setEventHandler { [weak self] in
            self?.onDirectoryDidChange?()
        }
        
        directoryObserverSource?.setCancelHandler { [weak self] in
            guard let strongSelf = self else { return }
            close(strongSelf.observedFolderFileDescriptor)
            strongSelf.observedFolderFileDescriptor = -1
            strongSelf.directoryObserverSource = nil
        }
        
        directoryObserverSource?.resume()
    }
    
    func stopObserving() {
        directoryObserverSource?.cancel()
    }
}
