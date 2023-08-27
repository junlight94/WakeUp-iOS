//
//  Log.swift
//  Core
//
//  Created by Junyoung on 2023/08/27.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

/// Develop 환경에서만 Log 찍히게
public final class Log {
    private init() {
    }
    
    private static let shared: Log = {
        let instance = Log()
        return instance
    }()
    
    public static func message(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if DEV
        let path = (file as NSString).lastPathComponent
        print("[\(path)-\(function):\(line)] - \(message())")
        #endif
    }
}
