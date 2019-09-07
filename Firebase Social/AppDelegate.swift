//
//  AppDelegate.swift
//  Firebase Social
//
//  Created by Denis Rakitin on 2019-09-05.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    


    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook
        
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        return true
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            debugPrint("Could not singIn with google: \(error.localizedDescription)")
        } else {
            guard let controller = GIDSignIn.sharedInstance()?.uiDelegate as? ViewController else {
                return
            }
            guard let authentication = user.authentication else {return }
             let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            controller.fireBaseLogin(credential)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let returnGoogle = (GIDSignIn.sharedInstance()?.handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))!
        
        let returnFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return returnGoogle || returnFacebook
     }

   
    
}

