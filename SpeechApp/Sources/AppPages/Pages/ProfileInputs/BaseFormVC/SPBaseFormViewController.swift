//
//  SPBaseFormViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseFormViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!;
    
    var profileModel : SPBaseEntryContainerModel = SPBaseEntryContainerModel();
    var imagePicker : UIImagePickerController?;
    var imagePickerModelKey : String?;
    var displayConstraintsErrors : Bool = false;
    var serviceRunning : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.tableView.allowsSelection = false;
        SPBaseEditableViewCell.registerTableViewIdentifiers(self.tableView);
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // setup scroll view navbar
        self.shyNavBarManager.scrollView = self.tableView;
    }
    
    // dismiss input views on table view scroll
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true);
    }
    // Dismiss keyboard when viewcontroller is touched
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    // MARK : TableViewDelegate & DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileModel.profileInfo.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.getTableViewCellAtIndex(tableView, indexPath: indexPath);
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.profileModel.profileInfo[indexPath.row].estimatedCellheight;
    }
    
    // get the table view cell
    func getTableViewCellAtIndex(tableView : UITableView, indexPath : NSIndexPath) -> SPBaseEditableViewCell {
        var profileEntry : SPProfileEntryModel = self.profileModel.profileInfo[indexPath.row];
        
        var cell : SPBaseEditableViewCell;
        switch profileEntry.type {
        case .TextName, .TextEmail, .TextPassword:
            var textCell : SPTextEditableViewCell = tableView.dequeueReusableCellWithIdentifier("SPTextEditableViewCellIdentifier", forIndexPath:indexPath) as! SPTextEditableViewCell;
            textCell.textField.delegate = self;
            textCell.textField.tag = indexPath.row;
            cell = textCell;
            break;
        case .Choice:
            var choiceCell : SPChoiceEditableViewCell = tableView.dequeueReusableCellWithIdentifier("SPChoiceEditableViewCellIdentifier", forIndexPath:indexPath) as! SPChoiceEditableViewCell;
            choiceCell.textField.tag = indexPath.row;
            choiceCell.textField.delegate = self;
            profileEntry.pickerView?.delegate = self;
            profileEntry.pickerView?.tag = indexPath.row;
            cell = choiceCell;
            break;
        case .Image:
            var imageCell : SPImageEditableViewCell = tableView.dequeueReusableCellWithIdentifier("SPImageEditableViewCellIdentifier", forIndexPath:indexPath) as! SPImageEditableViewCell;
            imageCell.pickerDelegate = self;
            cell = imageCell;
            break;
        case .Submit:
            var submitCell : SPSubmitEditableViewCell = tableView.dequeueReusableCellWithIdentifier("SPSubmitEditableViewCellIdentifier", forIndexPath:indexPath) as! SPSubmitEditableViewCell;
            submitCell.submitDelegate = self;
            cell = submitCell;
            break;
        default:
            cell = SPBaseEditableViewCell();
            break;
        }
        profileEntry.estimatedCellheight = cell.getHeight();
        profileEntry.displayConstraintsErrors = self.displayConstraintsErrors;
        cell.profileEntry = profileEntry;
        cell.reloadCell();
        
        return cell;
    }
    
    // MARK : UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // disable keyboard on enter pressed
        textField.resignFirstResponder();
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // disable copy/cut/paste for the entries of type Choice
        if self.profileModel.profileInfo[textField.tag].type == SPProfileEntryModelTypes.Choice {
            return false;
        }
        return true;
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        let profileModel = self.profileModel.profileInfo[textField.tag];
        if profileModel.type == SPProfileEntryModelTypes.Choice && profileModel.value == nil {
            profileModel.value = profileModel.choiceGeneratorModel?.defaultValue;
            self.setTableViewCellValue(profileModel.value!, rowNumber: textField.tag);
        }
    }
    
    // MARK : UIPickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let generatorModel = self.profileModel.profileInfo[pickerView.tag].choiceGeneratorModel {
            return generatorModel.values.count;
        }
        return 0;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if let generatorModel = self.profileModel.profileInfo[pickerView.tag].choiceGeneratorModel {
            return generatorModel.getValueAtIndex(row);
        }
        return "";
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set the model's value
        self.profileModel.profileInfo[pickerView.tag].value = self.profileModel.profileInfo[pickerView.tag].choiceGeneratorModel?.values[row];
        self.refreshRowAfterEditing(pickerView.tag);
    }
    
    func setTableViewCellValue(value : AnyObject, rowNumber:Int) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowNumber, inSection: 0));
        if let choiceCellView = cell as? SPChoiceEditableViewCell {
            choiceCellView.textField.text = SPUtils.convertAnyObjectToString(value);
        }
    }
    
    private func refreshRowAfterEditing(rowNumber : Int) {
        // reload only that cell (no need to load other cells)
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: rowNumber, inSection: 0)], withRowAnimation: .None);
        
        // get the cell and mark its textField as first responder to keep picker view up
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowNumber, inSection: 0));
        if let choiceCellView = cell as? SPChoiceEditableViewCell {
            choiceCellView.textField.becomeFirstResponder();
        }
    }
    
    // function called when a new profile image was saved
    func didAddImage(imagePath : String, imagePickerModelKey : String) {
        let index = self.profileModel.getEntryModelIndexFromKey(imagePickerModelKey);
        if index == -1 {
            return;
        }
        self.profileModel.profileInfo[index].value = imagePath;
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None);
    }
}
