//
//  NewsListCellView.swift
//  ReignDesign
//
//  Created by Delapille on 01/09/2017.
//  Copyright © 2017 Delapille. All rights reserved.
//

import Foundation
import UIKit

class NewsListCellView: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    static let identifier = "NewsListCellView"
}
