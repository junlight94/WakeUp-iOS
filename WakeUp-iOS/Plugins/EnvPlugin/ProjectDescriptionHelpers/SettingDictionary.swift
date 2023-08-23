//
//  SettingDictionary.swift
//  MyPlugin
//
//  Created by Junyoung on 2023/08/23.
//

import ProjectDescription

public extension SettingsDictionary {
    static let allLoadSettings: Self = [
        "OTHER_LDFLAGS" : [
            "$(inherited) -all_load",
            "-Xlinker -interposable"
        ]
    ]
    
    static let baseSettings: Self = [
        "OTHER_LDFLAGS" : [
            "$(inherited)",
            "-ObjC"
        ]
    ]
    
    func setCodeSignManual() -> SettingsDictionary {
        merging(["CODE_SIGN_STYLE": SettingValue(stringLiteral: "Manual")])
            .merging(["DEVELOPMENT_TEAM": SettingValue(stringLiteral: "TEAM")])
            .merging(["CODE_SIGN_IDENTITY": SettingValue(stringLiteral: "$(CODE_SIGN_IDENTITY)")])
    }
    
    func setProvisioningProd() -> SettingsDictionary {
        merging(["PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "")])
            .merging(["PROVISIONING_PROFILE": SettingValue(stringLiteral: "")])
    }
    
    func setProvisioningTest() -> SettingsDictionary {
        merging(["PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "")])
            .merging(["PROVISIONING_PROFILE": SettingValue(stringLiteral: "")])
    }
}
