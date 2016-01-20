//
//  THAHttpServerUtilities.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import SwiftHTTP

class THAHttpServerUtilities: THAHttpUtilities {
    override func get(methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        var request = HTTPTask();
        request.GET(String(format: "%@%@", arguments: [THAHttpUtilities.SERVER_BASE_URL, methodName]), parameters: parameters, completionHandler: {[weak self] (response: HTTPResponse) in
            self?.parseResponse(response, onError: onError, onSuccess: onSuccess);
        });
    }
    
    
    override func post(methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        var request = HTTPTask();
        request.POST(String(format: "%@%@", arguments: [THAHttpUtilities.SERVER_BASE_URL, methodName]), parameters: parameters, completionHandler: {[weak self] (response: HTTPResponse) in
            self?.parseResponse(response, onError: onError, onSuccess: onSuccess);
        })
    }
    
    private func generateBoundaryString() -> String {
        return "--------Boundary-\(NSUUID().UUIDString)----"
    }
    
    override func postFilesWithJson(methodName : String, jsonName : String, json : NSDictionary, filePaths : [String], onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        let boundary = self.generateBoundaryString();
        let beginningBoundary = "--\(boundary)";
        let endingBoundary = "--\(boundary)--";
        let contentType = "multipart/form-data;boundary=\(boundary)";
        
        var body = NSMutableData();
        
        var err: NSError?;
        body.appendData(("\(beginningBoundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        var header = "Content-Disposition: form-data; name=\"\(jsonName)\"\r\n\r\n"
        body.appendData((header as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        let data = NSJSONSerialization.dataWithJSONObject(json, options: nil, error: &err)!;
        body.appendData(NSString(data: data, encoding: NSUTF8StringEncoding)!.dataUsingEncoding(NSUTF8StringEncoding)!);
        body.appendData(("\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        
        for relativeFilePath in filePaths {
            let absoluteFilePath = SPUtils.getFullPathFromNSDocuments(relativeFilePath);
            
            if !NSFileManager.defaultManager().fileExistsAtPath(absoluteFilePath) {
                continue;
            }
            
            body.appendData(("\(beginningBoundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            var header = "Content-Disposition: form-data; name=\"file\"; filename=\"\(relativeFilePath)\"\r\n";
            body.appendData((header as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            body.appendData(("Content-Type: audio/mp4\r\n\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
            let data = NSData(contentsOfFile: absoluteFilePath);
            body.appendData(data!);

            body.appendData(("\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!);
        }
        
        body.appendData(("\r\n\(endingBoundary)\r\n" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: String(format: "%@%@", arguments: [THAHttpUtilities.SERVER_BASE_URL, methodName]))!)
        
        request.HTTPMethod = "POST";
        request.addValue(contentType, forHTTPHeaderField: "Content-Type");
        request.HTTPBody = body;
        var session = NSURLSession.sharedSession();
        var task = session.dataTaskWithRequest(request, completionHandler: {[weak self] (data, response, error) -> Void in
            if self == nil {
                return;
            }
            if (error != nil) {
                onError(THAHttpStatus.REQUEST_ERROR, error.localizedDescription);
            }
            else {
                if (data == nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        onError(THAHttpStatus.REQUEST_ERROR, "Received empty response from server");
                    });
                }
                else {
                    var error: NSError?;
                    
                    if let jsonObject : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) {
                        if let responseDict = jsonObject as? NSDictionary {
                            self?.parseServerJson(responseDict, onError: onError, onSuccess: onSuccess);
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), {
                                onError(THAHttpStatus.RESULT_FORMAT_BAD, "Bad response format from server! It is not a dictionary.");
                            });
                        }
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            onError(THAHttpStatus.RESULT_FORMAT_BAD, "Bad response format from server! It is not a dictionary.");
                        });
                    }
                }
            }
        });
        task.resume();
    }
    
    private func parseResponse(response: HTTPResponse, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        if let err = response.error {
            dispatch_async(dispatch_get_main_queue(), {
                onError(THAHttpStatus.REQUEST_ERROR, err.localizedDescription);
            });
            return;
        }
        else if let data = response.responseObject as? NSData {
            
            var error: NSError?;
            var responseDict: NSDictionary? = nil;
            if let jsonObject : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) {
                if let jsonDict = jsonObject as? NSDictionary {
                    responseDict = jsonDict;
                }
            }
            
            if(error != nil || responseDict == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    onError(THAHttpStatus.RESULT_FORMAT_BAD, "Bad response format from server! It is not a dictionary.");
                });
                return;
            }
            
            self.parseServerJson(responseDict!, onError: onError, onSuccess: onSuccess);
            return;
        }
    }
    
    private func parseServerJson(responseDict : NSDictionary, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        var parseError = true;
        
        if let statusCode = responseDict["StatusCode"] as? Int {
            if let responseObj = responseDict["Data"] as? NSObject {
                dispatch_async(dispatch_get_main_queue(), {
                    switch statusCode {
                    case THAHttpStatus.SUCCESS.rawValue:
                        onSuccess(responseObj);
                        break;
                    case THAHttpStatus.SESSION_TIMEOUT.rawValue:
                        self.notifySessionTimeout();
                        break;
                    default:
                        var errorMessage = "Server Error";
                        if let serverErrorMessage = responseDict["Message"] as? String {
                            errorMessage = serverErrorMessage;
                        }
                        onError(self.getHTTPStatusFromStatusCode(statusCode), errorMessage);
                        break;
                    }
                });
                parseError = false;
            }
        }
        
        if parseError {
            println("ERROR : Bad format : \(responseDict)");
            dispatch_async(dispatch_get_main_queue(), {
                onError(THAHttpStatus.RESULT_FORMAT_BAD, "Bad response format from server!");
            });
        }
    }
    
    private func getHTTPStatusFromStatusCode(statusCode : Int) -> THAHttpStatus {
        for httpStatus in THAHttpStatus.allValues {
            if httpStatus.rawValue == statusCode {
                return httpStatus;
            }
        }
        return THAHttpStatus.UNKNOWN_STATUS_CODE;
    }
}
