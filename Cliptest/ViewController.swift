//
//  ViewController.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import UIKit

class ViewController: UIViewController {
    var imv: UIImageView!
    var clipImv: UIImageView = UIImageView()
    
    var crop: ZYQuadRangleClipView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imv = UIImageView()
        imv.frame = self.view.bounds.inset(by: UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10))
        imv.contentMode = .scaleAspectFit
        imv.backgroundColor = .green
        
        let im =  UIImage(contentsOfFile: Bundle.main.path(forResource: "xxxas.jpg", ofType: nil)!)
        imv.image = im
        self.view.addSubview(imv)
        
        
        self.clipImv.alpha = 0
        self.clipImv.frame = imv.frame.inset(by: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        self.view.addSubview(self.clipImv)
        
        self.imv = imv

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        crop = ZYQuadRangleClipView()
        self.imv.addSubview(crop)
    }

    @IBAction func clipimgs(_ sender: Any) {
        if let cropimg =  self.crop.clipImage() {
            self.clipImv.image = cropimg
            UIView.animate(withDuration: 0.5) {
                self.clipImv.alpha = 1
                self.imv.alpha = 0
            }
        }
    }
}

