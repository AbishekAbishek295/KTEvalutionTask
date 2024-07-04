//
//  AppDelegate.swift
//  KTEvalutionTask
//
//  Created by abishek m on 29/06/24.
//

import UIKit
import Firebase
import GoogleSignIn
import RealmSwift
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {


    var locationManager: LocationManager?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyAOVYRIgupAurZup5y1PRh8Ismb1A3lLao")
        
        locationManager = LocationManager()
        FirebaseApp.configure()
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
        let realm = try! Realm()
        if let fileURL = realm.configuration.fileURL {
            print("URL: \(fileURL)")
        } else {
            print("Not available")
        }
        
        GIDSignIn.sharedInstance()?.clientID = "583665364576-76o96h08c4pb19451sjaujalvfp0ppnm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = user else {
            print("User is nil")
            return
        }
        
        guard let email = user.profile?.email else {
            print("User email is nil")
            return
        }
        
        print("User email: \(email)")
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

