//
//  AppDelegate.swift
//  ios-qube
//
//  Created by Junyoung Lee on 2023/07/10.
//  Copyright © 2023 Quriously. All rights reserved.
//

import UIKit
import Core
import DSKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if DEV
        print("Develop")
        #else
        print("Product")
        #endif
        
        /// 모든 의존성 생성
        registerAgoraService(appID: "e2f642e0bf04462fbcaf831501217b6a", channelID: "TEST", token: "007eJxTYHj5uMNc6cJ7sdli0sUZ9uUvOGs/ekl/evr0urrf54lLsqwUGFKN0sxMjFINktIMTEzMjNKSkhPTLIwNTQ0MjQzNk8wSxW/8T2kIZGTw8ihjYWSAQBCfhSHENTiEgQEAjXIfrw==", uid: 0, clientRole: .broadcaster)
        
        registerDependencies()
        
        /// 폰트 생성
        Fonts.fontInitialize()
        
        return true
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
