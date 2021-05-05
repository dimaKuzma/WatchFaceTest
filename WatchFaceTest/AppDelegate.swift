//
//  AppDelegate.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/25/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIStoryboard(name: "First", bundle: nil).instantiateInitialViewController() as! FirstViewController
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

