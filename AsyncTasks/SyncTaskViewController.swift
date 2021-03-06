//
//  SyncTaskViewController.swift
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

class SyncTaskViewController: UIViewController {

    lazy var model: RemoteModel = {
        return RemoteModel()
    }()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func fetch(sender: UIButton) {
        sender.hidden = true
        self.activityIndicator.startAnimating()
        let result = self.model.fetchSync()
        self.activityIndicator.stopAnimating()
        sender.hidden = false
        print("Sync Model fetch result: \(result)")
    }

}
