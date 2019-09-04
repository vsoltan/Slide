//
//  AppDelegate.swift
//  Slide
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // MARK: - PROPERTIES
    
    var window: UIWindow?
    
    // MARK: - API LOGIN
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            CustomError.createWith(errorTitle: "Google Login Error", errorMessage: error.localizedDescription)
            return
        } else {
            
            guard let userAuthDetails = user.authentication else { return }
            
            let loginHandler = GoogleLoginHandler()
            
            let generatedCredential = GoogleAuthProvider.credential(withIDToken: userAuthDetails.idToken, accessToken: userAuthDetails.accessToken)
            
            loginHandler.handleGoogleSignIn(for: generatedCredential) { (loginSuccessful) in
                if (loginSuccessful) {
                    loginHandler.presentApplication(from: self)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            CustomError.createWith(errorTitle: "Google Signout Error", errorMessage: error!.localizedDescription)
        } else {
            print("Successfully disconnected user from the application")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // API configs
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let fbconfig = ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        getPostLaunchWindow { (view) in
            
            guard let root = self.window?.rootViewController else { return }
            
            UIView.transition(from: root.view, to: view.view, duration: 0.5, options:
                .transitionCrossDissolve, completion: { (_) in
                self.window?.rootViewController = view
                self.window?.makeKeyAndVisible()
            })
        }
        return fbconfig
    }
    
    func getPostLaunchWindow(completion: @escaping (UIViewController) -> Void)  {
        
        let auth = Auth.auth()
        
        // if a user is already signed in
        if let user = auth.currentUser {
            AppUser.setLocalData(for: user.uid) { (error) in
                if (error == nil) {
                    completion(Container())
                } else {
                    print("could not complete login")
                }
            }
        } else {
            // placeholder while I implement login screen
            completion(Login())
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    // for iOS 8 or older
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

