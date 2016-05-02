//
//  RemoteModel.swift
//  AsyncTasks
//
//  Copyright 2016 Tien-Che Tsai
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SwiftyJSON
import Async

class RemoteModel {
    static let DidFinishFetchingNotification = "RemoteModelDidFinishFetchingNotification"

    weak var delegate: RemoteModelDelegate?

    func fetchSync() -> Int? {
        let delay = arc4random_uniform(3) + 1
        let url = NSURL(string: "https://httpbin.org/delay/\(delay)?answer=42")!
        guard let data = NSData(contentsOfURL: url) else {
            return nil
        }
        let json = JSON(data: data)
        guard let valueString = json["args"]["answer"].string else {
            return nil
        }
        return Int(valueString)
    }
}

// MARK: - Async with Callback Pattern

// MARK: With libdispatch

extension RemoteModel {
    func fetchAsyncCallback1(handler: (Int?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let result = self.fetchSync()
            dispatch_async(dispatch_get_main_queue()) {
                handler(result)
            }
        }
    }
}

// MARK: With SwiftAsync lib

extension RemoteModel {
    func fetchAsyncCallback2(handler: (Int?) -> Void) {
        var result: Int?
        Async.background {
            result = self.fetchSync()
        }.main {
            handler(result)
        }
    }
}

// MARK: - Async with Delegation Pattern

protocol RemoteModelDelegate: class {
    func remoteModel(model: RemoteModel, didFinishFetchingWithResult result: Int?)
}

extension RemoteModel {
    func fetchAsyncDelegate() {
        var result: Int?
        Async.background {
            result = self.fetchSync()
        }.main {
            self.delegate?.remoteModel(self, didFinishFetchingWithResult: result)
        }
    }
}

// MARK: - Async with Notification Pattern

extension RemoteModel {
    func fetchAsyncNotification() {
        var result: Int?
        Async.background {
            result = self.fetchSync()
        }.main {
            var userInfo = [NSObject : AnyObject]()
            if let resultValue = result {
                userInfo["result"] = resultValue
            }
            let notification = NSNotification(name: RemoteModel.DidFinishFetchingNotification,
                object: self,
                userInfo: userInfo)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
}
