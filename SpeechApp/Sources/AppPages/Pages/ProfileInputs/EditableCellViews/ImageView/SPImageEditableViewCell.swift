//
//  SPImageEditableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPImageEditableViewCell: SPBaseEditableViewCell {
    @IBOutlet weak var editableBackgroundView: UIView!;
    @IBOutlet weak var editableImageView: UIImageView!;
    @IBOutlet weak var editableButton: UIButton!;
    
    weak var pickerDelegate: SPBaseFormViewControllerImagePickerProtocol?;
    
    
    override func initCell() {
        self.editableBackgroundView.setRoundCorners();
        self.editableBackgroundView.setDefaultMarginColor();
    }
    override func reloadCell() {
        super.reloadCell();
        
        editableImageView.image = nil;
        editableImageView.imageURL = nil;
        
        if let imageUrl = self.profileEntry?.value as? String {
            let fileManager = NSFileManager.defaultManager();
            if fileManager.fileExistsAtPath(SPUtils.getFullPathFromNSDocuments(imageUrl)) {
                if let imageData = NSData(contentsOfFile: SPUtils.getFullPathFromNSDocuments(imageUrl)) {
                    editableImageView.image = UIImage(data: imageData);
                }
            }
            else {
                editableImageView.imageURL = NSURL(string: imageUrl);
            }
        }
        else {
            editableImageView.image = UIImage(named: "ProfileImagePlaceholder");
        }
        
        self.setNeedsLayout();
    }
    
    @IBAction func didTapEditableButton(sender: AnyObject) {
        self.pickerDelegate?.selectImageFromAlbum(self.profileEntry!.entryKey);
    }
    
    override func getHeight() -> CGFloat {
        return 101.0;
    }
}
