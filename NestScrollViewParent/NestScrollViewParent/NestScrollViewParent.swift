//
//  NestScrollViewParent.swift
//  AppLearn
//
//  Created by PXCM-0101-01-0045 on 2020/1/8.
//  Copyright © 2020 PXCM-0101-01-0045. All rights reserved.
//

import Foundation
import UIKit

class NestScrollViewParent: UIScrollView, UIGestureRecognizerDelegate {
    private var observedViews: [UIScrollView] = []
    private var _isObserving: Bool = false
    private var _isParentScroll: Bool = true
    private var _isChildScroll: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: contentOffset)), options: [.old, .new], context: nil)
        _isObserving = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return false
        }
        
        guard scrollView != self else {
            return false
        }
        
        if !observedViews.contains(scrollView) {
            observedViews.append(scrollView)
            scrollView.addObserver(self, forKeyPath: NSStringFromSelector(#selector(getter: contentOffset)), options: [.old, .new], context: nil)
        }
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let newOffSet = change?[NSKeyValueChangeKey.newKey] as? CGPoint, let oldOffSet = change?[NSKeyValueChangeKey.oldKey] as? CGPoint else {
            return
        }
        
        let direct: CGFloat = newOffSet.y - oldOffSet.y

        guard direct != 0 else {return}
        
        if !_isObserving {
            return
        }
        if direct > 0 {
            //上滑
            if (object as? NestScrollViewParent) == self {
                _isParentScroll = true
                if newOffSet.y + self.frame.height >= contentSize.height {
                    //                print("parent scoll finish")
                    setContentOffset(offset: CGPoint(x: self.contentOffset.x, y: contentSize.height - self.frame.height), to: self)
                    _isParentScroll =  false
                }
            } else if let scrollView = object as? UIScrollView {
                if _isParentScroll {
                    //                print("child scoll disable")
                    setContentOffset(offset: oldOffSet, to: scrollView)
                } else {
                    //                print("child scolling")
                }
            }
        } else if direct < 0 {
            //下滑
            if (object as? NestScrollViewParent) == self {
                if _isChildScroll {
                    //                print("child scoll disable")
                    setContentOffset(offset: oldOffSet, to: self)
                } else {
                    //                print("child scolling")
                }

            } else if let scrollView = object as? UIScrollView {
                _isChildScroll = true
                if newOffSet.y < 0 {
                    //                print("parent scoll finish")
                    setContentOffset(offset: CGPoint(x: scrollView.contentOffset.x, y: 0), to: scrollView)
                    _isChildScroll =  false
                }
            }
        }

    }
    
    private func setContentOffset(offset: CGPoint, to scrollView: UIScrollView) {
        _isObserving = false
        scrollView.contentOffset = offset
        _isObserving = true
    }
}
