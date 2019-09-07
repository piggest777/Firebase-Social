//
//  ViewController.swift
//  Firebase Social
//
//  Created by Denis Rakitin on 2019-09-05.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin


class ViewController: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate{


    
    //Outlets
    @IBOutlet weak var userInfoLbl: UILabel!
    @IBOutlet weak var facebookLoginBtn: FBLoginButton!
    
    
    //var
    let loginManager = LoginManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
//        self.facebookLoginBtn.delegate = self
        
        
        facebookLoginBtn.delegate = self
        facebookLoginBtn.frame = CGRect(x: 20, y: 156, width: view.frame.size.width - 40, height: 40)
        
        let loginButton = FBLoginButton(permissions: [ .publicProfile ])
//        facebookLoginBtn = FBLoginButton( permissions: [ .publicProfile ])
//        loginButton.center = view.center
        loginButton.frame = CGRect(x: 20, y: 228, width: view.frame.size.width - 40, height: 40)
        loginButton.delegate = self

        view.addSubview(loginButton)
       
        
       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.userInfoLbl.text = "No user logged in"
            } else {
                self.userInfoLbl.text = "Welcome user: \(user?.uid ?? "Anon")"
            }
        }
        
    }
    
    
    @IBAction func customGoogleSignInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func googleSigninTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        let fireBaseAuth = Auth.auth()
        do {
            logOutSocial()
            try fireBaseAuth.signOut()
        } catch let signOutError as NSError {
            debugPrint("Error signingOut", signOutError)
        }
    }
    
    func fireBaseLogin (_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                debugPrint("Unable to sign in with Google: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func logOutSocial () {
        guard  let user = Auth.auth().currentUser else {
            return
        }
        for info in (user.providerData) {
            switch info.providerID {
            case  GoogleAuthProviderID:
                print("google")
                GIDSignIn.sharedInstance()?.signOut()
            case TwitterAuthProviderID:
                print("twitter")
            case FacebookAuthProviderID:
                loginManager.logOut()
                print("facebook")
            default:
                break
            }
        }
    }
    
    
    @IBAction func customFacebookTapped(_ sender: Any) {
        
        loginManager.logIn(permissions: [ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                self.fireBaseLogin(credential)
                print("Logged in!")
                
                
            }
    }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if let error = error {
            debugPrint("Failed facebook login", error)
            return
        }
        
        if result?.isCancelled == true {
            print("User cancelled login.")
        }
        else {
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            fireBaseLogin(credential)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        handle log out
    }
    
}

