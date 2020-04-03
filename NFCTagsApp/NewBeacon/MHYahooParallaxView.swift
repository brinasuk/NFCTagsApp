//  Converted to Swift 5.1 by Swiftify v5.1.33867 - https://objectivec2swift.com/
//
// MHYahooParallaxView
// iamkel.net
//
//  Created by Michael Henry Pantaleon on 18/07/2014.
//  Copyright (c) 2014 Michael Henry Pantaleon. All rights reserved.
//
// Version 1.0.1
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

enum MHYahooParallaxViewType : Int {
    case horizontal = 0
    case vertical = 1
}

@objc protocol MHYahooParallaxViewDatasource: NSObjectProtocol {
    func numberOfRows(in parallaxView: MHYahooParallaxView?) -> Int
    func parallaxView(_ parallaxView: MHYahooParallaxView?, cellForRowAt indexPath: IndexPath?) -> UICollectionViewCell?
}

@objc protocol MHYahooParallaxViewDelegate: NSObjectProtocol {
    @objc optional func parallaxViewDidScrollHorizontally(_ parallaxView: MHYahooParallaxView?, leftIndex: Int, leftImageLeftMargin: CGFloat, leftImageWidth: CGFloat, rightIndex: Int, rightImageLeftMargin: CGFloat, rightImageWidth: CGFloat)
    @objc optional func parallaxViewDidScrollVertically(_ parallaxView: MHYahooParallaxView?, topIndex: Int, topImageTopMargin: CGFloat, topImageHeight: CGFloat, bottomIndex: Int, bottomImageTopMargin: CGFloat, bottomImageHeight: CGFloat)
}

class MHYahooParallaxView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var pageDivisor: CGFloat = 0.0
    var dataCount = 0
    var separatorWidth: CGFloat = 0.0

    var parallaxCollectionView: UICollectionView?
    var parallaxViewType: MHYahooParallaxViewType?
    weak var datasource: MHYahooParallaxViewDatasource?
    weak var delegate: MHYahooParallaxViewDelegate?

    private var _currentIndex = 0
    var currentIndex: Int {
        get {
            _currentIndex
        }
        set(index) {
            //TODO: ALEX
            //WILL CAUSE CRASH setCurrentIndex(index, animated: false)
        }
    }

    init(frame: CGRect, with viewType: MHYahooParallaxViewType) {
        super.init(frame: frame)
        let layout = MHYahooParallaxCollectionViewLayout()
        separatorWidth = 5.0
        layout.separatorWidth = separatorWidth
        self.frame.size.width = frame.size.width + separatorWidth
        
        parallaxCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        parallaxCollectionView?.delegate = self
        parallaxCollectionView?.dataSource = self
        parallaxCollectionView?.isPagingEnabled = true
        parallaxViewType = viewType

        if let parallaxCollectionView = parallaxCollectionView {
            addSubview(parallaxCollectionView)
        }
    }

    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier reuseIdentifier: String) {
        parallaxCollectionView?.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func cellForItem(at indexPath: IndexPath?) -> UICollectionViewCell? {
        if let indexPath = indexPath {
            return parallaxCollectionView?.cellForItem(at: indexPath)
        }
        return nil
    }

    func dequeueReusableCell(withReuseIdentifier reuseIdentifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return (parallaxCollectionView?.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath))!
    }

    func setCurrentIndex(_ index: Int, animated: Bool) {
        currentIndex = index
        //TODO: ALEX
        parallaxCollectionView!.setContentOffset(CGPoint(x: CGFloat(index) * width, y: 0.0), animated: animated)
    }

    convenience override init(frame: CGRect) {
        self.init(frame: frame, with: .horizontal)
    }

    override func layoutSubviews() {

        super.layoutSubviews()
        width = frame.size.width
        height = frame.size.height


    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if datasource?.responds(to: #selector(NewBeaconViewController.numberOfRows(in:))) ?? false {
            dataCount = datasource?.numberOfRows(in: self) ?? 0
        }
        return dataCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if datasource?.responds(to: #selector(NewBeaconViewController.parallaxView(_:cellForRowAt:))) ?? false {
            cell = datasource?.parallaxView(self, cellForRowAt: indexPath)
        }
        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / (width + separatorWidth))


        if parallaxViewType == .horizontal {

            var leftIndex = -1
            var rightIndex = -1

            leftIndex = currentIndex

            if currentIndex < (dataCount - 1) {
                rightIndex = leftIndex + 1
            }

            let leftImageMargingLeft: CGFloat = scrollView.contentOffset.x > 0 ? (fmod(scrollView.contentOffset.x + width + separatorWidth, width + separatorWidth)) : 0.0
            let leftImageWidth = (width + separatorWidth) - (fmod(abs(scrollView.contentOffset.x + separatorWidth), width + separatorWidth))
            let rightImageMarginLeft: CGFloat = 0.0
            let rightImageWidth = leftImageMargingLeft - separatorWidth

            if delegate?.responds(to: #selector(NewBeaconViewController.parallaxViewDidScrollHorizontally(_:leftIndex:leftImageLeftMargin:leftImageWidth:rightIndex:rightImageLeftMargin:rightImageWidth:))) ?? false {
                delegate?.parallaxViewDidScrollHorizontally?(self, leftIndex: leftIndex, leftImageLeftMargin: leftImageMargingLeft, leftImageWidth: leftImageWidth, rightIndex: rightIndex, rightImageLeftMargin: rightImageMarginLeft, rightImageWidth: rightImageWidth)
            }
        } else {

            var topIndex = -1
            var bottomIndex = -1

            topIndex = currentIndex

            if currentIndex < (dataCount - 1) {
                bottomIndex = topIndex + 1
            }

            let topImageTopMargin: CGFloat = scrollView.contentOffset.y > 0 ? (fmod(scrollView.contentOffset.y + height, height)) : 0.0
            let topImageHeight = height - (fmod(abs(scrollView.contentOffset.y), height))
            let bottomImageTopMargin: CGFloat = 0.0
            let bottomImageHeight = topImageTopMargin

            if delegate?.responds(to: #selector(MHYahooParallaxViewDelegate.parallaxViewDidScrollVertically(_:topIndex:topImageTopMargin:topImageHeight:bottomIndex:bottomImageTopMargin:bottomImageHeight:))) ?? false {

                delegate?.parallaxViewDidScrollVertically?(self, topIndex: topIndex, topImageTopMargin: topImageTopMargin, topImageHeight: topImageHeight, bottomIndex: bottomIndex, bottomImageTopMargin: bottomImageTopMargin, bottomImageHeight: bottomImageHeight)
            }
        }
    }

    deinit {
        parallaxCollectionView = nil
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
