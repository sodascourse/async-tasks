//
//  AsyncDelegateTaskViewController.swift
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

import UIKit

class AsyncDelegateTaskViewController: UIViewController, RemoteModelDelegate {

    lazy var model: RemoteModel = {
        let remoteModel = RemoteModel()
        remoteModel.delegate = self
        return remoteModel
    }()

    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func fetch(sender: AnyObject) {
        self.fetchButton.hidden = true
        self.activityIndicator.startAnimating()
        self.model.fetchAsyncDelegate()
    }

    func remoteModel(model: RemoteModel, didFinishFetchingWithResult result: Int?) {
        self.activityIndicator.stopAnimating()
        self.fetchButton.hidden = false
        print("Async Delegate Model fetch result: \(result)")
    }
}
