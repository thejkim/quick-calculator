//
//  JLog.swift
//  QuickCalculator
//
//  Created by Joeun Kim on 10/18/17.
//

import UIKit

func JLog(_ message:String? = nil, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
    var msgString = "[\((file as NSString).lastPathComponent).\(function)() :\(line)]"
    if let msg = message {
        msgString += " " + msg
    }
    print(msgString)
    #endif
}

func JLog(_ message:String? = nil, CGSize size:CGSize, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
    var msgString = "[\((file as NSString).lastPathComponent).\(function)() :\(line)]"
    msgString += "\((message ?? ""))) CGSize(w: \(size.width) h: \(size.height)"
    print(msgString)
    #endif
}

func JLog(_ message:String? = nil, CGRect rect:CGRect, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
    var msgString = "[\((file as NSString).lastPathComponent).\(function)() :\(line)]"
    msgString += "\((message ?? "")) CGRect(x: \(rect.origin.x) y: \(rect.origin.y) w: \(rect.size.width) h: \(rect.size.height)"
    print(msgString)
    #endif
}
