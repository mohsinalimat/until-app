//
//  CardView.swift
//  Until
//
//  Created by Kiran Kunigiri on 2/10/18.
//  Copyright © 2018 Kiran Kunigiri. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    // MARK: Outlets
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var contentView: UIView?
    var fillLayer: CALayer?
    var time: Double = 0
    var percent: Double = 0 {
        didSet {
            fillLayer!.frame.size.width = CGFloat(percent) * self.frame.size.width
        }
    }
    @IBInspectable var nibName: String?

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        viewSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }
    
    func viewSetup() {
        contentView = loadViewFromNib(nibName: "CardView")
        
        // Clipping sublayers
        contentView?.layer.masksToBounds = true
        contentView?.clipsToBounds = true
        
        // Setup fill layer
        fillLayer = CALayer()
        fillLayer?.frame = self.bounds
        fillLayer?.backgroundColor = UIColor(red:0.33, green:0.52, blue:0.99, alpha:1.0).cgColor
        self.contentView!.layer.insertSublayer(fillLayer!, at: 0)
        
        // UI Setup
        percent = 0
        contentView?.layer.cornerRadius = 14
        
        animated()
    }
    
    func animated() {
        var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        guard time <= 1 else { return }
        time = time + 0.01
        percent = time
        percentLabel.text = "\(Int(percent*100))%"
        fillLayer!.backgroundColor = blend(from: UIColor(red:1.00, green:0.56, blue:0.39, alpha:1.0), to: UIColor(red:0.33, green:0.52, blue:0.99, alpha:1.0), percent: time).cgColor
    }

}


func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor {
    var fR : CGFloat = 0.0
    var fG : CGFloat = 0.0
    var fB : CGFloat = 0.0
    var tR : CGFloat = 0.0
    var tG : CGFloat = 0.0
    var tB : CGFloat = 0.0
    
    from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
    to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)
    
    let dR = tR - fR
    let dG = tG - fG
    let dB = tB - fB
    
    let rR = fR + dR * CGFloat(percent)
    let rG = fG + dG * CGFloat(percent)
    let rB = fB + dB * CGFloat(percent)
    
    return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
}
