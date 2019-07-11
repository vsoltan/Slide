//
//  AppDelegate.swift
//  Slide
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // Signin function for Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            CustomError.createWith(errorTitle: "Google Login Error", errorMessage: error.localizedDescription).show()
            return
        } else {
            
            // Send the user to Google's login system
            guard let authentication = user.authentication else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                // Successfully logged in with Google
                if error == nil {

                    let db = Firestore.firestore()
                    
                    let userID = Auth.auth().currentUser!.uid
                    
                    // creates firestore document for Google user
                    db.collection("users").document(userID).setData([
                        // set specified data entries
                        "Name": authResult?.user.displayName as Any,
                        "ID": userID,
                        "Email": authResult?.user.email as Any,
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    // store Google user's data locally
                    User.getUser(userID: Auth.auth().currentUser!.uid, completionHandler: { (error) in
                        if (error != nil) {
                            print("something went wrong")
                        } else {
                            // print results to console and take user to Home
                            print(authResult?.user.email as Any)
                            print(authResult?.user.displayName as Any)
                            
                            // initializes the container for the view controller
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            
                            // specifies the destination and creates an instance of that view controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Home")
                            
                            // sets the root view controller to the desination and renders it
                            self.window?.rootViewController = initialViewController
                            let currusr = Auth.auth().currentUser
                            User.getUser(userID: currusr!.uid) { (error) in}
                            self.window?.makeKeyAndVisible()
                        }
                    })
                }
                // Failed
                else {
                    print(error?.localizedDescription as Any)
                    CustomError.createWith(errorTitle: "Google Authentication Error", errorMessage: error!.localizedDescription).show()
                }
            }
            
        }
    }
    
    // TODO: after making sure Google works at all, consider implementing the other methods (i.e. didDisconnect) provided by the Firebase docs
    
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // use Firebase library to configure APIs
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let fbconfig = ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // checks if user is already signed in
        let currusr = Auth.auth().currentUser
        
        if (currusr != nil) {

            // initializes the container for the view controller
            self.window = UIWindow(frame: UIScreen.main.bounds)

            // specifies the destination and creates an instance of that view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Home")

            // sets the root view controller to the desination and renders it
            self.window?.rootViewController = initialViewController

            User.getUser(userID: currusr!.uid) { (error) in}
            self.window?.makeKeyAndVisible()
        }
        return fbconfig
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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

