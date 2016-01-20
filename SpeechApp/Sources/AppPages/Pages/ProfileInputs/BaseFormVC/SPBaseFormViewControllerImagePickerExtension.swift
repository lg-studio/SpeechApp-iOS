//
//  SPBaseFormViewControllerImagePickerExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

protocol SPBaseFormViewControllerImagePickerProtocol : class {
    func selectImageFromAlbum(cellKey : String);
}

extension SPBaseFormViewController : SPBaseFormViewControllerImagePickerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func selectImageFromAlbum(cellKey : String) {
        self.imagePickerModelKey = cellKey;
        
        if self.imagePicker == nil {
            self.imagePicker = UIImagePickerController();
        }
        self.imagePicker?.delegate = self;
        
        var alert:UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet);
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera();
        }
        var gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallery();
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(cameraAction);
        alert.addAction(gallaryAction);
        alert.addAction(cancelAction);
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            self.imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera;
            self .presentViewController(self.imagePicker!, animated: true, completion: nil);
        }
        else {
            SPUtils.displayAlertController("Warning", message: "You don't have camera on your device", viewController: self);
        }
    }
    private func openGallery() {
        self.imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.presentViewController(self.imagePicker!, animated: true, completion: nil);
    }
    
    // MARK : UIImagePickerControllerDelegate implementation
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil);
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.finishImageProcessing(pickedImage);
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePicker = nil;
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    // finish the image selection
    func finishImageProcessing(image : UIImage) {
        let scaledImage = self.shrinkImage(image);
        let imagePath = self.saveImageToDocumentsDirectory(scaledImage);
        if imagePath != nil && self.imagePickerModelKey != nil {
            self.didAddImage(imagePath!, imagePickerModelKey: self.imagePickerModelKey!);
        }
    }
    
    private func computeNewSize(size : CGSize) -> CGSize {
        if size.width < 320.0 {
            return size;
        }
        var widthRatio = 320.0 / size.width;
        var newSize = CGSize(width: 320.0, height: size.height * widthRatio);
        return newSize;
    }
    
    private func shrinkImage (imageObj:UIImage)-> UIImage{
        var sizeChange = self.computeNewSize(imageObj.size);
        
        let hasAlpha = false;
        let scale: CGFloat = 1.0; // do not use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale);
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange));
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        return scaledImage;
    }
    
    private func saveImageToDocumentsDirectory(image : UIImage) -> String? {
        let relativePath = "profile_picture.jpg";
        let path = SPUtils.getFullPathFromNSDocuments(relativePath);
        let imageData = UIImageJPEGRepresentation(image, 0.0);
        
        var error : NSError?;
        NSFileManager.defaultManager().removeItemAtPath(path, error: &error);
        let success = imageData.writeToFile(path, atomically: true);
        if !success {
            return nil;
        }
        
        return relativePath;
    }
}
