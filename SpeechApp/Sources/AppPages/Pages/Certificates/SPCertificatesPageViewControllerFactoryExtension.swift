//
//  SPCertificatesPageViewControllerFactoryExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit


extension SPCertificatesPageViewController {
    
    func getModelAtIndex(index : Int) -> NSObject? {
        var currentIndex = 0;
        
        for certificate in self.certificatesModel!.certificates {
            if currentIndex == index {
                return certificate;
            }
            currentIndex += 1;
            if certificate.expanded {
                for subcertificate in certificate.subcertificates {
                    if currentIndex == index {
                        return subcertificate;
                    }
                    currentIndex += 1;
                }
            }
        }
        return nil;
    }
    
    func getNumberOfCells() -> Int {
        var totalCount = 0;

        for certificate in self.certificatesModel!.certificates {
            totalCount += 1;
            if certificate.expanded {
                totalCount += certificate.subcertificates.count;
            }
        }

        return totalCount;
    }
    
    func getTableViewCellAtIndex(indexPath : NSIndexPath, tableView : UITableView) -> UITableViewCell {
        let objectModel = self.getModelAtIndex(indexPath.row);
        
        if let certificate = objectModel as? SPCertificateItemModel {
            var cell : SPCertificateItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPCertificateItemTableViewCellIdentifier", forIndexPath:indexPath) as! SPCertificateItemTableViewCell;
            
            cell.certificate = certificate;
            cell.reloadCell();
            return cell;            
        }
        else if let subcertificate = objectModel as? SPCertificateSubcategoryItemModel {
            var cell : SPSubcertificateItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPSubcertificateItemTableViewCellIdentifier", forIndexPath:indexPath) as! SPSubcertificateItemTableViewCell;
            
            cell.subcertificate = subcertificate;
            cell.reloadCell();
            return cell;
        }
        else {
            return UITableViewCell();
        }
    }
    
}
