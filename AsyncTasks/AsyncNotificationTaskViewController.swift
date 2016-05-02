//
//  AsyncNotificationTaskViewController.swift
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

class AsyncNotificationTaskViewController: UIViewController {

    var model: RemoteModel!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = RemoteModel()
        NSNotificationCenter.defaultCenter().addObserver(self,
             selector: #selector(AsyncNotificationTaskViewController.fetchDidFinishNotification(_:)),
             name: RemoteModel.DidFinishFetchingNotification,
             object: self.model)
    }

    func fetchDidFinishNotification(notification: NSNotification) {
        defer {
            self.activityIndicator.stopAnimating()
            self.fetchButton.hidden = false
        }

        guard let result = notification.userInfo?["result"] as? Int else {
            return
        }
        print("Async Notification Model fetch result: \(result)")
    }

    @IBAction func fetch(sender: UIButton) {
        self.fetchButton.hidden = true
        self.activityIndicator.startAnimating()
        self.model.fetchAsyncNotification()
    }

}
