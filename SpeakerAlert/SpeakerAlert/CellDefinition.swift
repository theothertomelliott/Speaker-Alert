//
//  CellDefinition.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/8/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

protocol CellDefinition {
    var title: String { get set }
    func cell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol CellWithAction {
    func performAction()
}

struct SectionDefinition {
    var title: String = ""
    var cells: [CellDefinition] = []
}
