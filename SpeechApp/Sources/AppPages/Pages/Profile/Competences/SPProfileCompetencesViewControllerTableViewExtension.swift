//
//  SPProfileCompetencesViewControllerTableViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPProfileCompetencesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.competencesModel.competences.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let competence : SPProfileCompentenceEntryModel = self.competencesModel.competences[indexPath.row];
        var cell : SPProfileCompetenceBaseTableViewCell;
        switch competence.type! {
        case .Header:
            cell = tableView.dequeueReusableCellWithIdentifier("SPProfileCompetenceHeaderTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileCompetenceHeaderTableViewCell;
            break;
        case .Category:
            cell = tableView.dequeueReusableCellWithIdentifier("SPProfileCompetenceCategoryTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileCompetenceCategoryTableViewCell;
            break;
        case .SubcategoryWithHeader:
            cell = tableView.dequeueReusableCellWithIdentifier("SPProfileSubcategoryWithHeaderTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileSubcategoryWithHeaderTableViewCell;
            break;
        case .Subcategory:
            cell = tableView.dequeueReusableCellWithIdentifier("SPProfileSubcategoryTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileSubcategoryTableViewCell;
            break;
        }
        cell.competence = competence;
        cell.reloadCell();
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        let competence : SPProfileCompentenceEntryModel = self.competencesModel.competences[indexPath.row];
        SPUtils.displayAlertController(competence.getCompetenceName(), message: competence.getCompetenceDescription(), viewController: self);
    }
}
