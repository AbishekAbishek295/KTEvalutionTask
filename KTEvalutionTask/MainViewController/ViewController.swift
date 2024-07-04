//
//  ViewController.swift
//  KTEvalutionTask
//
//  Created by abishek m on 29/06/24.
//

import UIKit
import GoogleSignIn
import Firebase
import RealmSwift


class UserData: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var userId = ""
    @objc dynamic var fullName = ""
    @objc dynamic var email = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    
    
//MARK: Save user data to Realm
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error: \(error.localizedDescription)")
                return
            }
            
            
            let realm = try! Realm()
            let userData = UserData()
            userData.userId = user.userID
            userData.fullName = user.profile.name
            userData.email = user.profile.email
            
            try! realm.write {
                realm.add(userData, update: .modified)
            }
            
            print("User signed in: \(user.profile.name ?? "No Name"), \(user.profile.email ?? "No Email")")
            self.navigateToLocationListViewController()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User has disconnected")
    }
    
    
     func navigateToLocationListViewController() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let locationListVC = storyboard.instantiateViewController(withIdentifier: "LocationListViewController") as? LocationListViewController {
             self.navigationController?.pushViewController(locationListVC, animated: true)
         }
     }
    
}



    

    
 

