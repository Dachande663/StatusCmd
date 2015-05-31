//
//  AppDelegate.swift
//  StatusCmd
//
//  Created by Luke Lanchester on 09/05/2015.
//  Copyright (c) 2015 Luke Lanchester. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    let filemanager = NSFileManager.defaultManager()
    let filename = ".statuscmd"
    var file: String = ""
    
    let resources = NSBundle.mainBundle().resourcePath
    
    let statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem = NSStatusItem()

    
    override func awakeFromNib() {
        
        file = NSHomeDirectory() + "/" + filename
        
        if (!filemanager.fileExistsAtPath(file)) {
            makeDefaultFile(file)
        }
        
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.highlightMode = true
        if resources != nil {
            statusBarItem.image = NSImage(contentsOfFile: resources!.stringByAppendingPathComponent("logo.png"))
        }

        updateMenu()
        
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("updateMenu"), userInfo: nil, repeats: true)
        
    }
    
    
    func makeDefaultFile(file: String) {
        
        if resources == nil {
            return
        }
        
        let path = resources!.stringByAppendingPathComponent("default.json")
        
        filemanager.copyItemAtPath(path, toPath: file, error: nil)
    
    }
    
    
    func updateMenu() {
        
        var rootMenu = NSMenu()
        
        if !filemanager.fileExistsAtPath(file) {
            var item = NSMenuItem()
            item.title = "Unable to open file"
            rootMenu.addItem(item)
            statusBarItem.menu = rootMenu
            return
        }
        
        let data = NSData(contentsOfFile: file)!
        let json = JSON(data: data)
        
        // statusBarItem.title = json["bar"]["title"].stringValue
        
        if(json["menu"] == nil) {
            var item = NSMenuItem()
            item.title = "Unable to read JSON"
            rootMenu.addItem(item)
        } else {
            populateMenu(rootMenu, jsonMenu: json["menu"])
        }

        statusBarItem.menu = rootMenu
       
    }
    
    
    func populateMenu(menu: NSMenu, jsonMenu: JSON) {
        
        for (key: String, jsonItem: JSON) in jsonMenu {
            menu.addItem(makeItem(jsonItem))
        }
        
    }
    
    
    func makeItem(jsonItem: JSON) -> NSMenuItem {
        
        if(jsonItem["separator"].boolValue == true) {
            return NSMenuItem.separatorItem()
        }
        
        var item = NSMenuItem()
        
        item.title = jsonItem["title"].stringValue
        
        if(jsonItem["enabled"].bool == false) {
            item.enabled = false
        } else {
            item.representedObject = jsonItem.object
            item.action = Selector("onClick:")
        }
        
        if let jsonMenu = jsonItem["menu"].array {
            var submenu = NSMenu()
            populateMenu(submenu, jsonMenu: jsonItem["menu"])
            item.submenu = submenu
        }
        
        return item
        
    }
    
    
    func onClick(sender: AnyObject) {
        
        let json = JSON(sender.representedObject as! NSDictionary)
        
        if let command = json["command"].string {
            if let args = json["arguments"].arrayObject {
                let task = NSTask()
                task.launchPath = json["command"].stringValue
                task.arguments = json["arguments"].arrayObject!
                task.launch()
            }
        }
        
    }
    

}

