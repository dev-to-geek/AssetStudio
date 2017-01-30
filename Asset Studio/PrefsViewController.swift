//
//  PrefsViewController.swift
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

import Cocoa

class PrefsViewController: NSViewController, NSComboBoxDataSource {
    
    let DM = DataModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        DM.sizeArray.sort(by: <)
        
        updateSizeLabel()
        comboSizes.usesDataSource = true
        comboSizes.dataSource = self
        
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return DM.sizeArray.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return DM.sizeArray[index]
    }
    
    func updateSizeLabel(){
        lblAllSizes.stringValue = ""
        for x in DM.sizeArray{
            lblAllSizes.stringValue = lblAllSizes.stringValue+String(x)+" "
        }
    }
    
    //MARK: view controls
    
    @IBOutlet weak var txNewSize: NSTextField!
    @IBOutlet weak var comboSizes: NSComboBox!
    @IBOutlet weak var lblAllSizes: NSTextField!
    
    //MARK: actions
    
    @IBAction func btnOkClick(_ sender: NSButton) {
        DM.saveArray()
        dismissViewController(self)
    }
    
    
    @IBAction func btnAddClick(_ sender: NSButton) {
        if txNewSize.integerValue != 0 {
            DM.sizeArray.append(txNewSize.integerValue)
            DM.sizeArray.sort(by: <)
            comboSizes.reloadData()
            updateSizeLabel()
        }else{
            txNewSize.stringValue = ""
        }
    }
    
    @IBAction func btnDeleteClick(_ sender: NSButton) {
        if comboSizes.indexOfSelectedItem != -1 {
            DM.sizeArray.remove(at: comboSizes.indexOfSelectedItem)
            comboSizes.stringValue = ""
            comboSizes.reloadData()
            updateSizeLabel()
        }
    }
    
    @IBAction func btnResetSizes(_ sender: NSButton) {
        let alert:NSAlert = NSAlert()
        alert.messageText = "Attenzione"
        alert.informativeText = "Sei sicuro di voler ripristinare tutti i valori?"
        alert.addButton(withTitle: "Si")
        alert.addButton(withTitle: "No")
        
        if(alert.runModal() == 1000){
            DM.resetDefaults()
            updateSizeLabel()
            comboSizes.reloadData()
        }
    }
    
}
