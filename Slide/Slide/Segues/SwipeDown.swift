//
//  SwipeDown.swift
//  Slide
//
//  Created by Valeriy Soltan on 7/1/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit

class SwipeDown: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        // superimpose the destination view controller over the source
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: 0, y: -src.view.frame.size.width * 2)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.0, options: .curveEaseInOut, animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { finished in
            src.present(dst, animated: false, completion: nil)})
    }
}
