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

class MHYahooParallaxCollectionViewLayout: UICollectionViewLayout {
    var itemSize = CGSize.zero

    var separatorWidth: CGFloat = 0.0

    override init() {
        super.init()
        separatorWidth = 0
    }

    override func prepare() {
        //TODO: CHANGED THIS
        var boundSize = collectionView!.bounds.size
        boundSize.width = (boundSize.width) - separatorWidth
        itemSize = boundSize

    }

    override var collectionViewContentSize: CGSize {
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        let cvSize = CGSize(width: (collectionView?.bounds.size.width ?? 0.0) * CGFloat(numberOfItems), height: collectionView?.bounds.size.height ?? 0.0)
        return cvSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        //TODO: FIX THIS
        var cw:CGFloat = 0.0
        cw = abs(collectionView?.bounds.size.width ?? 0.0 - separatorWidth)
        
        attributes.center = CGPoint(x: (separatorWidth * CGFloat(indexPath.row)) + (CGFloat(indexPath.row) * cw) + cw / 2, y: (collectionView?.bounds.size.height ?? 0.0) / 2)
        
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [AnyHashable] = []
        var i = 0, j = collectionView?.numberOfItems(inSection: 0)
        while i < j! {
            let indexPath = IndexPath(item: i, section: 0)
            if let layout = layoutAttributesForItem(at: indexPath) {
                attributes.append(layout)
            }
            i += 1
        }
        return attributes as? [UICollectionViewLayoutAttributes]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
