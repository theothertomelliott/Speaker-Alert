//
//  ActionCell.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/8/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit


struct ActionCellDefinition: CellDefinition, CellWithAction {
    var title: String = ""
    var detail: String?
    var hasDisclosure: Bool = false
    var action: () -> () = {_ in}
    
    func performAction() {
        self.action()
    }
    
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "ActionCell",
            forIndexPath: indexPath
        )
        if let c = cell as? ActionCell {
            c.titleLabel?.text = self.title
            c.detailTextLabel?.hidden = true
            if self.hasDisclosure {
                c.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } else {
                c.accessoryType = UITableViewCellAccessoryType.None
            }
            if let d = self.detail {
                c.detailTextLabel?.hidden = false
                c.detailTextLabel?.text = d
            }
        }
        return cell
    }
}

class ActionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
}
