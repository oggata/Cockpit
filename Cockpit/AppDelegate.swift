//
//  AppDelegate.swift
//  MilitaryChannel
//
//  Created by Fumitoshi Ogata on 2015/12/16.
//  Copyright © 2015年 Fumitoshi Ogata. All rights reserved.
//

import UIKit
import RMPScrollingMenuBarController
import SwiftyJSON

struct Const{
    static let kAppGroupIdentifier = "aaa"
    static let API_KEY : String = "api-key"
    static let API_ENDPOINT_SEARCH : String = "https://www.googleapis.com/youtube/v3/search"
    static let API_ENDPOINT_VIDEOS : String = "https://www.googleapis.com/youtube/v3/videos"
    static let KeyWord : JSON = [
        "list":[
            [
                "name" : "Fighter",
                "q":"F15,F16,Cockpit"
            ],
            [
                "name" : "Jet",
                "q":"JetPlane,Cockpit"
            ],
            [
                "name" : "Airliner",
                "q":"Airliner,Cockpit"
            ],
            [
                "name" : "Cessna",
                "q":"Cessna,Cockpit"
            ],
            [
                "name" : "Helicopter",
                "q":"Helicopter,Cockpit"
            ],
            [
                "name" : "TakeOff",
                "q":"TakeOff,Cockpit"
            ],
            [
                "name" : "Landing",
                "q":"Landing,Cockpit"
            ],
            [
                "name" : "AirRace",
                "q":"AirRace,Cockpit"
            ],
            [
                "name" : "JumboJet",
                "q":"jumbojet,Cockpit"
            ],
            [
                "name" : "JumboJet",
                "q":"jumbojet,Cockpit"
            ],
        ]
    ]
}

extension UINavigationBar
{
    override public func sizeThatFits(size: CGSize) -> CGSize
    {
        let newSize:CGSize = CGSizeMake(self.frame.size.width, 60)
        
        return newSize
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var videoId : String?
    var videoId2 : String = "videId"
    var isFull:Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let tab1: UIViewController = mainStoryboard .instantiateViewControllerWithIdentifier("navigation_to_setting_view")
        
        let menuController = RMPScrollingMenuBarController()
        menuController.delegate = self
        menuController.view.backgroundColor = UIColor(red:33/255,green:73/255,blue:125/255,alpha:1.0)
        menuController.menuBar.indicatorColor = UIColor(red:33/255,green:73/255,blue:125/255,alpha:1.0)
        menuController.menuBar.itemInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        menuController.title = "Cockpit-Ch"
        menuController.menuBar.tintColor = UIColor(red:33/255,green:73/255,blue:125/255,alpha:1.0)
        
        var viewControllers: [UINavigationController] = []
        for var i = 0 ; i < 8 ; ++i {
            let mcTableView: UINavigationController = mainStoryboard .instantiateViewControllerWithIdentifier("navigation_to_mctable_view") as! UINavigationController
            let titleLabel = Const.KeyWord["list"][i]["name"].string!
            mcTableView.topViewController!.title = titleLabel;
            mcTableView.view.backgroundColor = UIColor.redColor()
            viewControllers.append(mcTableView)
        }
        menuController.setViewControllers(viewControllers, animated: true)
        
        let navigationController = UINavigationController(rootViewController: menuController)
        navigationController.navigationBar.barTintColor = UIColor(red:33/255,green:73/255,blue:125/255,alpha:1.0)
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:22)!]

        tab1.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 1)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 2)
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(
            [
                navigationController,
                tab1
            ], animated: true)
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: RMPScrollingMenuBarControllerDelegate {
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, willSelectViewController viewController: UIViewController!) {
        print("will select \(viewController)")
    }
    
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, didSelectViewController viewController: UIViewController!) {
        print("did select \(viewController.title)")
    }
    
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, didCancelViewController viewController: UIViewController!) {
        print("did cancel \(viewController)")
    }
    
    func menuBarController(menuBarController: RMPScrollingMenuBarController!, menuBarItemAtIndex index: Int) -> RMPScrollingMenuBarItem! {
        let item = RMPScrollingMenuBarItem()
        let titleLabel = Const.KeyWord["list"][index]["name"].string!
        item.title = titleLabel
        let button = item.button()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Disabled)
        button.setTitleColor(UIColor.redColor(), forState: .Selected)
        return item
    }
}


