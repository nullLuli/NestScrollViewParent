//
//  TestNestScrollViewParent.swift
//  AppLearn
//
//  Created by PXCM-0101-01-0045 on 2020/1/8.
//  Copyright © 2020 PXCM-0101-01-0045. All rights reserved.
//

import Foundation
import UIKit

class TestNestScrollViewParent: UIViewController, UIScrollViewDelegate {
    
    var parentScroll: NestScrollViewParent = NestScrollViewParent()
    var parentImageView: UIImageView = UIImageView(image: UIImage(named: "img2"))
    
    var childScroll: UIScrollView = UIScrollView()
    var childImageView: UIImageView = UIImageView(image: UIImage(named: "img1"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(parentScroll)
        parentScroll.frame = CGRect(x: 0, y: 100, width: 300, height: 400)
        parentScroll.addSubview(parentImageView)
        parentImageView.frame.size = CGSize(width: 300, height: 500)
        
        parentScroll.addSubview(childScroll)
        childScroll.frame = parentScroll.frame
        childScroll.addSubview(childImageView)
        childImageView.frame.size = CGSize(width: 300, height: 500)
        
        parentScroll.contentSize = CGSize(width: 0, height: 500)
        childScroll.contentSize = CGSize(width: 0, height: 500)
                
        parentScroll.delegate = self
        childScroll.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == parentScroll {
            print("parentScroll \(scrollView.contentOffset)")
        } else if scrollView == childScroll {
            print("childScroll \(scrollView.contentOffset)")
        }
    }
}
