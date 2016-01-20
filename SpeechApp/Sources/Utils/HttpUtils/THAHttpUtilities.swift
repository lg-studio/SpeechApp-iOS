//
//  THAHttpUtilities.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import SwiftHTTP
import MONActivityIndicatorView

enum THAHttpStatus : Int {
    // internal status codes
    case UNKNOWN_STATUS_CODE            =   -3
    case RESULT_FORMAT_BAD              =   -2
    case REQUEST_ERROR                  =   -1
    
    // server status codes
    case SUCCESS                        =   0
    case SESSION_TIMEOUT                =   1

    case SESSION_NOT_AVAILABLE          =   2
    case LOGIN_FAIL                     =   3
    case SERVER_ERROR                   =   4
    case RESOURCE_NOT_FOUND             =   5
    case SIGN_UP_ACCOUNT_ALREADY_EXISTS =   6
    case INCORRECT_PASSWORD             =   7
    case EMAIL_NOT_RECOGNIZED           =   8
    case ACCOUNT_NOT_ACTIVATED          =   9

    
    static let allValues = [SUCCESS, SESSION_TIMEOUT, SESSION_NOT_AVAILABLE, LOGIN_FAIL, SERVER_ERROR, RESOURCE_NOT_FOUND, SIGN_UP_ACCOUNT_ALREADY_EXISTS, INCORRECT_PASSWORD, EMAIL_NOT_RECOGNIZED, ACCOUNT_NOT_ACTIVATED]
};

enum THAHttpUtilitiesKeys : String {
    case ServerURL      =   "SpeechApp_ServerURL"
    case MocksEnabled   =   "SpeechApp_LocalMocksEnabled"
}

class THAHttpUtilities: NSObject {
    static let indicatorViewColors = [  UIColor(red: 216.0/255, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1.0),
                                        UIColor.lightGrayColor(),
                                        UIColor(red: 252.0/255, green: 207.0/255.0, blue: 71.0/255.0, alpha: 1.0),
                                        UIColor(red: 44.0/255, green: 100.0/255.0, blue: 214.0/255.0, alpha: 1.0),
                                        UIColor(red: 43.0/255, green: 169.0/255.0, blue: 96.0/255.0, alpha: 1.0)
                                     ];
    
    static var SERVER_BASE_URL : String {
        get {
            if let serverUrlStr = NSBundle.mainBundle().infoDictionary?[THAHttpUtilitiesKeys.ServerURL.rawValue] as? String {
                return serverUrlStr;
            }
            return "";
        }
    }
    
    private static let httpUtilitiesInstance = THAHttpUtilities.httpUtilities;
    private static var httpUtilities : THAHttpUtilities {
        get {
            var localMocksEnabled = false;
            if let localMocksEnabledProp = NSBundle.mainBundle().infoDictionary?[THAHttpUtilitiesKeys.MocksEnabled.rawValue] as? Bool {
                if localMocksEnabledProp {
                    println("[INFO] Local mocks are enabled!");
                    return THAHttpMockUtilities();
                }
            }
            return THAHttpServerUtilities();
        }
    }
    static func getHttpUtilities() -> THAHttpUtilities {
        return THAHttpUtilities.httpUtilitiesInstance;
    }
    
    
    // instance methods
    func get(methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
    }
    func post(methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
    }
    func getAnimated(view:UIView, methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        view.addActivityIndicator();
        self.get(methodName, parameters: parameters,
            onError: {[weak view, weak self] (statusCode: THAHttpStatus, status : String) in
                UIView.removeActivityIndicator(view);
                onError(statusCode, status);
            }, onSuccess: {[weak view, weak self] (data : NSObject) in
                UIView.removeActivityIndicator(view);
                onSuccess(data);
            });
    }
    func postAnimated(view:UIView, methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        view.addActivityIndicator();
        self.post(methodName, parameters: parameters,
            onError: {[weak view, weak self] (statusCode: THAHttpStatus, status : String) in
                UIView.removeActivityIndicator(view);
                onError(statusCode, status);
            }, onSuccess: {[weak view, weak self] (data : NSObject) in
                UIView.removeActivityIndicator(view);
                onSuccess(data);
            });
    }
    
    func postFilesWithJson(methodName : String, jsonName : String, json : NSDictionary, filePaths : [String], onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
    }
    
    func postFilesWithJsonAnimated(view:UIView, methodName : String, jsonName : String, json : NSDictionary, filePaths : [String], onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        
        view.addActivityIndicator();
        self.postFilesWithJson(methodName, jsonName: jsonName, json : json, filePaths : filePaths,
            onError: {[weak view, weak self] (statusCode: THAHttpStatus, status : String) in
                UIView.removeActivityIndicator(view);
                onError(statusCode, status);
            }, onSuccess: {[weak view, weak self] (data : NSObject) in
                UIView.removeActivityIndicator(view);
                onSuccess(data);
            });
    }
    
    func notifySessionTimeout() {
        let newQuoteCreatedNotification = NSNotification(name: SPUtils.LOGOUT_NOTIFICATION, object: true);
        NSNotificationCenter.defaultCenter().postNotification(newQuoteCreatedNotification);
    }
    
}