//
//  ViewController.swift
//  Asset Maker
//
//  Created by Mircha Emanuel D'Angelo on 16/01/17.
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

class ViewController: NSViewController {
    
    let DM = DataModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillAppear() {
        self.view.window!.title = "Dev2Geek - Asset Studio"
        
        scale = (self.view.window?.backingScaleFactor)!
      
    }
    
    //MARK: variables
    
    var scale:CGFloat = 0
    
    var pathSet = false
    
    //MARK: functions
    func resizeImage(_ inputImage: NSImage, size: CGFloat, filePath: NSString) {
        let newSize = NSSize(width: size/scale, height: size/scale)
        let targetFrame: NSRect = NSMakeRect(0, 0, newSize.width, newSize.height)
        let sourceImageRep: NSImageRep = inputImage.bestRepresentation(for: targetFrame, context: nil, hints: nil)!
        let outputImage = NSImage(size: newSize)
        outputImage.lockFocus()
        sourceImageRep.draw(in: targetFrame)
        let bitmapRep: NSBitmapImageRep = NSBitmapImageRep(focusedViewRect: NSMakeRect(0, 0, targetFrame.width, targetFrame.height))!
        outputImage.unlockFocus()
        
        let imageData:Data = bitmapRep.representation(using: NSBitmapImageFileType.PNG, properties: NSDictionary() as! [String: AnyObject])!
        try? imageData.write(to: URL(fileURLWithPath: filePath as String), options: [])
        
    }
    

    func showAlertSheet(_ info: String){
        let alert: NSAlert = NSAlert()
        alert.messageText = "Asset Maker"
        alert.informativeText = info
        alert.alertStyle = NSAlertStyle.informational
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }
    
    //MARK: Chain functions
    
    func showPrefs(_ sender: AnyObject){
        let SB = NSStoryboard(name: "Main", bundle: nil)
        
        let PVC = SB.instantiateController(withIdentifier: "prefsViewControl") as! PrefsViewController
        self.presentViewControllerAsSheet(PVC)
    }
    
    func go(_ sender: AnyObject){
        guard let _ = self.imageView.image else {
            showAlertSheet("Nesuna immagine selezionata")
            return
        }
        
        guard pathSet == true else {
            showAlertSheet("Nessuna directory di esportazione impostata")
            return
        }
        
        if self.txtBaseName.stringValue.isEmpty {
            self.txtBaseName.stringValue = self.txtBaseName.placeholderString!
        }
        
        let image = self.imageView.image
        var strFullPath = ""
        var size = 0
        
        for count in 0 ..< DM.sizeArray.count {
            size = DM.sizeArray[count]
            strFullPath = (self.pathControl.url?.path)! + "/" + self.txtBaseName.stringValue + "-" + String(size) + ".png"
            resizeImage(image!, size: CGFloat(size), filePath: strFullPath as NSString)
            
            
            strFullPath = (self.pathControl.url?.path)! + "/" + self.txtBaseName.stringValue + "-" + String(size) + "x2.png"
            resizeImage(image!, size: CGFloat(size*2), filePath: strFullPath as NSString)
        }
        
        showAlertSheet("Esportazione completata")
    }
    
    func selectImage(_ sender: AnyObject){
        let FO = NSOpenPanel()
        
        FO.canChooseFiles = true
        FO.canChooseDirectories = false
        FO.canCreateDirectories = false
        FO.allowsMultipleSelection = false
        FO.message = "Seleziona l'immagine base da cui genereare l'asset di icone"
        FO.allowedFileTypes = NSImage.imageTypes()
        
        let compl = {
            (res: Int) in
            if res == NSModalResponseOK {
                self.imageView.image = NSImage(contentsOfFile: (FO.url?.path)!)
            }
        }
        FO.beginSheetModal(for: self.view.window!, completionHandler: compl)
        
    }
    
    func selectOutputFolder(_ sender: AnyObject){
        let FO = NSOpenPanel()
        
        FO.canChooseDirectories = true
        FO.canChooseFiles = false
        FO.canCreateDirectories = true
        FO.allowsMultipleSelection   = false
        
        FO.message = "Seleziona la directory in cui esportare le icone"
        
        FO.beginSheetModal(for: self.view.window!, completionHandler: { (res: Int) in
            
            if res == NSModalResponseOK {
                self.pathControl.url = FO.url
                self.pathSet = true
            }
        })
    }
    
    //MARK: subview controls
    
    @IBOutlet weak var pathControl: NSPathControl!
    @IBOutlet weak var lblFileName: NSTextField!
    @IBOutlet weak var txtBaseName: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    
    //MARK: actions
    
    @IBAction func txtChanged(_ sender: NSTextField) {
        var basename: String
        if self.txtBaseName.stringValue.isEmpty {
            basename = self.txtBaseName.placeholderString!
        }else{
            basename = self.txtBaseName.stringValue
        }
        self.lblFileName.stringValue = basename  + "-XXxN.png"
    }
    
}

