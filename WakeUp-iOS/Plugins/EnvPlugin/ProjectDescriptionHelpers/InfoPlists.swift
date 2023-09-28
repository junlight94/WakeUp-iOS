//
//  InfoPlists.swift
//  MyPlugin
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription

public extension Project {
    static let appInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "0.1.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.quriously.qube",
        "CFBundleDisplayName": "WakeUp",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "UIRequiresFullScreen": true,
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ITSAppUsesNonExemptEncryption": false,
        "NSMicrophoneUsageDescription": "마이크 권한 설정",
        "NSCameraUsageDescription": "카메라 권한 설정",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIAppFonts": [
            "Item 0": "SpoqaHanSansNeo-Bold.ttf",
            "Item 1": "SpoqaHanSansNeo-Regular.ttf",
            "Item 2": "SpoqaHanSansNeo-Light.ttf",
            "Item 3": "SpoqaHanSansNeo-Medium.ttf",
            "Item 4": "SpoqaHanSansNeo-Thin.ttf"
        ]
    ]
    
    static let signInInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "0.1.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.quriously.qube.test",
        "CFBundleDisplayName": "신청 데모앱",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "UIRequiresFullScreen": true,
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ITSAppUsesNonExemptEncryption": false,
        "NSMicrophoneUsageDescription": "마이크 권한 설정",
        "NSCameraUsageDescription": "카메라 권한 설정",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIAppFonts": [
            "Item 0": "SpoqaHanSansNeo-Bold.ttf",
            "Item 1": "SpoqaHanSansNeo-Regular.ttf",
            "Item 2": "SpoqaHanSansNeo-Light.ttf",
            "Item 3": "SpoqaHanSansNeo-Medium.ttf",
            "Item 4": "SpoqaHanSansNeo-Thin.ttf"
        ]
    ]
    
    static let waitingRoomInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "0.1.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.quriously.qube.test",
        "CFBundleDisplayName": "대기실 데모앱",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "UIRequiresFullScreen": true,
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ITSAppUsesNonExemptEncryption": false,
        "NSMicrophoneUsageDescription": "마이크 권한 설정",
        "NSCameraUsageDescription": "카메라 권한 설정",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIAppFonts": [
            "Item 0": "SpoqaHanSansNeo-Bold.ttf",
            "Item 1": "SpoqaHanSansNeo-Regular.ttf",
            "Item 2": "SpoqaHanSansNeo-Light.ttf",
            "Item 3": "SpoqaHanSansNeo-Medium.ttf",
            "Item 4": "SpoqaHanSansNeo-Thin.ttf"
        ]
    ]
    
    static let meetingInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "0.1.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.quriously.qube.test",
        "CFBundleDisplayName": "미팅 데모앱",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "UIRequiresFullScreen": true,
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ITSAppUsesNonExemptEncryption": false,
        "NSMicrophoneUsageDescription": "마이크 권한 설정",
        "NSCameraUsageDescription": "카메라 권한 설정",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIAppFonts": [
            "Item 0": "SpoqaHanSansNeo-Bold.ttf",
            "Item 1": "SpoqaHanSansNeo-Regular.ttf",
            "Item 2": "SpoqaHanSansNeo-Light.ttf",
            "Item 3": "SpoqaHanSansNeo-Medium.ttf",
            "Item 4": "SpoqaHanSansNeo-Thin.ttf"
        ]
    ]
    
    static let calendarInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "0.1.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.quriously.qube.test",
        "CFBundleDisplayName": "캘린더 데모앱",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "UIRequiresFullScreen": true,
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ITSAppUsesNonExemptEncryption": false,
        "NSMicrophoneUsageDescription": "마이크 권한 설정",
        "NSCameraUsageDescription": "카메라 권한 설정",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UIAppFonts": [
            "Item 0": "SpoqaHanSansNeo-Bold.ttf",
            "Item 1": "SpoqaHanSansNeo-Regular.ttf",
            "Item 2": "SpoqaHanSansNeo-Light.ttf",
            "Item 3": "SpoqaHanSansNeo-Medium.ttf",
            "Item 4": "SpoqaHanSansNeo-Thin.ttf"
        ]
    ]
}
