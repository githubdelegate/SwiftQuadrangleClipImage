//
//  ViewController.swift
//  Cliptest
//
//  Created by edz on 2021/6/17.
//

import UIKit

class ViewController: UIViewController {

    
    var imv: UIImageView!
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
        
        self.imv = imv
        self.imv.isUserInteractionEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        crop = ZYQuadRangleClipView()
        self.imv.addSubview(crop)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            crop.clip()
//        }
    }

    @IBAction func clipimgs(_ sender: Any) {
        
        if let cropimg =  self.crop.clip() {
            self.imv.image = cropimg
        }
        
    }
}

