//
//  ViewController.swift
//  BlockManDynamics
//
//  Created by XueYu on 11/23/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let kHeadInitialPosition = CGRect(x:135, y: 100, width: 50, height: 50)
    let kTorsoInitialPosition = CGRect(x:155, y: 150, width: 10, height: 100)
    let kUpperLegInitialPosition = CGRect(x:140, y: 250, width: 40, height: 10)
    let kLeftLegInitialPosition = CGRect(x:130, y: 250, width: 10, height: 40)
    let kRightLegInitialPosition = CGRect(x:180, y: 250, width: 10, height: 40)
    let kLeftUpperArmInitialPosition = CGRect(x:115, y: 170, width: 40, height: 10)
    let kRightUpperArmInitialPosition = CGRect(x:165, y: 170, width: 40, height: 10)
    let kLeftLowerArmInitialPosition = CGRect(x:105, y: 170, width: 10, height: 40)
    let kRightLowerArmInitialPosition = CGRect(x:205, y: 170, width: 10, height: 40)

    var bodyParts = [UIView]()
    var animator = UIDynamicAnimator.init()
    var gravity = UIGravityBehavior.init()
    var head = UIView.init()
    var torso = UIView.init()
    var upperLegs = UIView.init()
    var leftLeg = UIView.init()
    var rightLeg = UIView.init()
    var upperLeftArm = UIView.init()
    var upperRightArm = UIView.init()
    var lowerLeftArm = UIView.init()
    var lowerRightArm = UIView.init()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createBlockMan()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        view.addGestureRecognizer(tap)
        
        
        let headTap = UITapGestureRecognizer.init(target: self, action: #selector(headTapped(_:)))
        head.addGestureRecognizer(headTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Create walls as the boundary of view
    func createWalls() {
        let collisionBehavior = UICollisionBehavior.init(items: bodyParts)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        let headBounce = UIDynamicItemBehavior.init(items: [head])
        headBounce.elasticity = 0.75
        animator.addBehavior(headBounce)
    }
    
    /// Create block man for dynamic effects
    func createBlockMan() {
        head = UIView.init(frame: kHeadInitialPosition)
        view.addSubview(head)
        
        let leftEye = UIView.init(frame: CGRect.init(x: 15, y: 15, width: 5, height: 5))
        leftEye.backgroundColor = UIColor.white
        head.addSubview(leftEye)
        
        let rightEye = UIView.init(frame: CGRect.init(x: 30, y: 15, width: 5, height: 5))
        rightEye.backgroundColor = UIColor.white
        head.addSubview(rightEye)
        
        let mouth = UIView.init(frame: CGRect.init(x: 15, y: 35, width: 20, height: 3))
        mouth.backgroundColor = UIColor.white
        head.addSubview(mouth)
        
        torso = UIView(frame: kTorsoInitialPosition)
        view.addSubview(torso)
        
        upperLegs = UIView(frame: kUpperLegInitialPosition)
        view.addSubview(upperLegs)
        
        leftLeg = UIView(frame: kLeftLegInitialPosition)
        view.addSubview(leftLeg)
        
        rightLeg = UIView(frame: kRightLegInitialPosition)
        view.addSubview(rightLeg)
        
        upperLeftArm = UIView(frame: kLeftUpperArmInitialPosition)
        view.addSubview(upperLeftArm)
        
        upperRightArm = UIView(frame: kRightUpperArmInitialPosition)
        view.addSubview(upperRightArm)
        
        lowerLeftArm = UIView(frame: kLeftLowerArmInitialPosition)
        view.addSubview(lowerLeftArm)
        
        lowerRightArm = UIView(frame: kRightLowerArmInitialPosition)
        view.addSubview(lowerRightArm)
        
        bodyParts = [head,torso,upperLegs,leftLeg,rightLeg,upperLeftArm,upperRightArm,lowerLeftArm,lowerRightArm]
        
        bodyParts.forEach(){ $0.backgroundColor = UIColor.black }
    }
    
    
    @objc func tapRecognized(_ sender: UITapGestureRecognizer) {
        gravity = UIGravityBehavior.init(items: bodyParts)
        animator = UIDynamicAnimator.init(referenceView: view)
        
        let tapPoint = sender.location(in: view)
        let direction = CGVector.init(dx: (tapPoint.x - self.view.center.x)/(self.view.frame.size.width/2),
                                      dy: (tapPoint.y - self.view.center.y)/(self.view.frame.size.height/2))
        changeGravityDirection(direction: direction)
        animator.addBehavior(gravity)
        
        createWalls()
    }
    
    
    @objc func headTapped(_ sender: UITapGestureRecognizer) {
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
            initialSpringVelocity: 20,
            options: .curveLinear,
            animations: {
                self.bodyParts.forEach({ (view) in
                    view.transform = .identity
                    self.head.frame = self.kHeadInitialPosition
                    self.torso.frame = self.kTorsoInitialPosition
                    self.upperLegs.frame = self.kUpperLegInitialPosition
                    self.leftLeg.frame = self.kLeftLegInitialPosition
                    self.rightLeg.frame = self.kRightLegInitialPosition
                    self.upperRightArm.frame = self.kRightUpperArmInitialPosition
                    self.upperLeftArm.frame = self.kLeftUpperArmInitialPosition
                    self.lowerRightArm.frame = self.kRightLowerArmInitialPosition
                    self.lowerLeftArm.frame = self.kLeftLowerArmInitialPosition
                
                })
        }) { (finished) in
            self.createWalls()
        }
    }
    
    
    func changeGravityDirection(direction: CGVector) {
        gravity.gravityDirection = direction
    }
}

