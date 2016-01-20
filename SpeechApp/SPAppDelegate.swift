//
//  AppDelegate.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit


@UIApplicationMain
class SPAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.registerForInternetConnectionChanges();
        
        // init custom nav bar
        SPNavBarCustomizer.initNavBar();
        
        // load cookies
        self.loadCookies();
        
        // send the chat inputs if on WiFi
        self.loadChatInputsIfConnectedToWiFi();
        
        // register for push notifications
        self.registerForPushNotificationsInApp(application);
        
        // register for logout notifications
        self.registerForLogoutNotifications();
        
        // REMOVE BEFORE SUBMITTING
        if(getenv("NSZombieEnabled") != nil || getenv("NSAutoreleaseFreedObjectCheckEnabled") != nil) {
            println ("NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
        }
        
        // set the root view controller of the app
        //let rootVC = SPMainContainerViewController();
        //let chatPageVC = SPChatPageViewController(taskTemplateType: .RegularTask,taskTemplateId: "552d077f00c97637a01c120b", taskName: "Chat Example", optionId: nil, subOptionId: nil);
        let rootVC = UINavigationController(rootViewController: SPLaunchScreenViewController());
        self.window?.rootViewController = rootVC;
        
        
        // facebook sdk
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions);
        
        // Register Crashlytics with Fabric.
        Fabric.with([Crashlytics()]);
        
        return true;
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        // facebook sdk
        let fbSDK = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation);
        // or google sdk if not facebook
        let googleSDK = GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation);

        return fbSDK || googleSDK;
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.saveCookies();
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp();
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveCookies();
    }

    // Reachability functions -> when connected to the WiFi, send the results
    func registerForInternetConnectionChanges() {
        let reachability = Reachability.reachabilityForInternetConnection();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability);
        reachability.startNotifier();
    }
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability;
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                var chatInputsDatabase : SPChatInputsDatabase = SPChatInputsDatabase.getChatInputDatabase();
                chatInputsDatabase.sendAllEntriesToServer();
            }
        }
    }
    
    func loadChatInputsIfConnectedToWiFi() {
        if SPUtils.deviceIsConnectedOverWiFi() {
            var chatInputsDatabase : SPChatInputsDatabase = SPChatInputsDatabase.getChatInputDatabase();
            chatInputsDatabase.sendAllEntriesToServer();
        }
    }
    
    func registerForLogoutNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doLogout:", name: SPUtils.LOGOUT_NOTIFICATION, object: nil);
    }
    
    func doLogout(notification: NSNotification) {
        var isSessionTimeout = false;
        if let isSessionTimeoutBool = notification.object as? Bool {
            isSessionTimeout = isSessionTimeoutBool;
        }
        let loginNC = UINavigationController(rootViewController: SPLoginPageViewController(isSessionTimeout: isSessionTimeout));
        UIView.transitionWithView(self.window!, duration: 0.6, options: .TransitionFlipFromLeft, animations: {
            let oldState = UIView.areAnimationsEnabled();
            UIView.setAnimationsEnabled(false);
            self.window?.rootViewController = loginNC;
            UIView.setAnimationsEnabled(oldState);
        }, completion: nil);
    }
    
    func loadCookies() {
        SPCookieManager().loadCookies();
    }
    func saveCookies() {
        SPCookieManager().saveCookies();
    }
}

