//
//  SPCertificateContainerModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPCertificateContainerModel: NSObject {
    static let CertificatesKey = "Certificates";
    var inited : Bool;
    
    var certificates : [SPCertificateItemModel];
    override init() {
        self.inited = false;
        self.certificates = [];

        super.init();
    }
    
    func getCertificates(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: "CertificatesNavigationTree", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let certificatesArray = dataDict.objectForKey(SPCertificateContainerModel.CertificatesKey) as? NSArray {
                        for certificateData in certificatesArray {
                            if let certificateDict = certificateData as? NSDictionary {
                                self?.certificates.append(SPCertificateItemModel(inputDict : certificateDict));
                            }
                        }
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }
}
