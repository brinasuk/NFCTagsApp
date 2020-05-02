//  Converted to Swift 5.1 by Swiftify v5.1.33867 - https://objectivec2swift.com/
//
//  MHTsekotCell.swift
//  CollectViewTest
//
//  Created by Michael Henry Pantaleon on 4/08/2014.
//  Copyright (c) 2014 Michael Henry Pantaleon. All rights reserved.
//

let IMAGE_SCROLL_VIEW_TAG = 100
let IMAGE_VIEW_TAG = 90
let CONTENT_IMAGE_VIEW_TAG = 80

import UIKit

class MHTsekotCell: UICollectionViewCell {
    var tsekotTableView: UITableView?

    private weak var _datasource: UITableViewDataSource?
    weak var datasource: UITableViewDataSource? {
        get {
            _datasource
        }
        set(datasource) {
            if tsekotTableView?.dataSource == nil {
                tsekotTableView?.dataSource = datasource
            }
        }
    }

    private weak var _delegate: UITableViewDelegate?
    weak var delegate: UITableViewDelegate? {
        get {
            _delegate
        }
        set(delegate) {
            if tsekotTableView?.delegate == nil {
                tsekotTableView?.delegate = delegate
            }
        }
    }

    class func reuseIdentifier() -> String? {
        //TODO:
        return "ALEX" //NSStringFromClass(MHTsekotCell.self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        tsekotTableView = UITableView(frame: frame, style: .plain)
        if let tsekotTableView = tsekotTableView {
            contentView.addSubview(tsekotTableView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //TODO: contentView.frame.size.width
        //let wid = contentView.frame.size.width
        //wid = 640.0
        
        //NSLog("WIDTH: %@",contentView.frame.size.width)
        tsekotTableView!.frame = CGRect(x: 0.0, y: 0.0, width: contentView.frame.size.width, height: contentView.frame.size.height)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


