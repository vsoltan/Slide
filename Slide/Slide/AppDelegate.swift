//
//  AppDelegate.swift
//  Slide
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//
// hi from Jen

import UIKit
import GoogleSignIn
import FacebookCore
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // handles the google signin process
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
//            // perform any operations on signed in user here.
//            let userId = user.userID                  // for client-side use only!
//            let idToken = user.authentication.idToken // safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//             ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // perform any operations when the user disconnects from app here.
        // ...
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // use Firebase library to configure APIs
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = "705100307106-3ivsiu3cbvjv2drsihtdbv5nkc8vmblk.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
//        UIApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // checks if user is already signed in
        if (Auth.auth().currentUser == nil) {
            print("user is not logged in")
            
            // initializes the container for the view controller
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            // specifies the destination and creates an instance of that view controller
            let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            
            // sets the root view controller to the desination and renders it
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Activates Facebook Events
//        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

