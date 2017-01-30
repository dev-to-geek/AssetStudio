//
//  DataModel.swift
//  Asset Maker
//
//  Created by Mircha Emanuel D'Angelo on 17/01/17.
//  Copyright © 2017 Mircha Emanuel D'Angelo. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.

import Foundation

class DataModel {
    static let sharedInstance = DataModel()
    static let sizeArrayKey = "sizeArray"
    
    private init(){
        if let array = UserDefaults.standard.array(forKey: DataModel.sizeArrayKey) {
            sizeArray = array as! [Int]
        }else{
            loadDefaults()
        }
    }
    
    fileprivate var dataChanged = false
    
    fileprivate func loadDefaults(){
         sizeArray = [16, 29, 32, 40, 60, 76, 84, 128, 256, 512]
    }
    
    var sizeArray = [Int]() {
        didSet{
            dataChanged = true
        }
    }
    
    func saveArray(){
        if dataChanged == true {
            UserDefaults.standard.set(sizeArray, forKey: DataModel.sizeArrayKey)
        }
    }
    
    func resetDefaults(){
        loadDefaults()
    }
    
}
