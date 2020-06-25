//
//  Stamp.swift
//  StampCamera
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

class Stamp: UIImageView, UIGestureRecognizerDelegate {
    
    var currentTrunsform:CGAffineTransform? = nil
    var scale: CGFloat = 1.0
    var angle: CGFloat = 0
    var isMoving:Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
        self.superview?.bringSubviewToFront(self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first!
        let dx = touch.location(in: self.superview).x - touch.previousLocation(in: self.superview).x
        let dy = touch.location(in: self.superview).y - touch.previousLocation(in: self.superview).y
        self.center = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
    }

    override func didMoveToSuperview() {
            
            
            let rotesionRecognizer:UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(Stamp.rotatonGesture(gesture:)))
            
            
            
            rotesionRecognizer.delegate = self
            
            self.addGestureRecognizer(rotesionRecognizer)
            
            
            let pinchRecognizer:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(Stamp.pinchGesture(gesture:)))
            
            pinchRecognizer.delegate = self
            
            self.addGestureRecognizer(pinchRecognizer)
        }
        
      
    @objc func rotatonGesture(gesture: UIRotationGestureRecognizer){
            print("Rotation detected!")
            
            if !isMoving && gesture.state == UIGestureRecognizer.State.began {
                isMoving = true
                currentTrunsform = self.transform
            }
            else if !isMoving && gesture.state == UIGestureRecognizer.State.ended{
                isMoving = false
                scale = 1.0
                angle = 0.0
            }
            
            angle = gesture.rotation
            
        let transform = currentTrunsform?.concatenating(CGAffineTransform(rotationAngle: angle)).concatenating(CGAffineTransform(scaleX: scale, y: scale))
            
        self.transform = transform!
        }
        
      
    @objc func pinchGesture(gesture: UIPinchGestureRecognizer){
            print("Pinch detected!")
            
            if !isMoving && gesture.state == UIGestureRecognizer.State.began {
                isMoving = true
                currentTrunsform = self.transform
            }
            else if !isMoving && gesture.state == UIGestureRecognizer.State.ended{
                isMoving = false
                scale = 1.0
                angle = 0.0
            }
            
            scale = gesture.scale
            
        let transform = currentTrunsform?.concatenating(CGAffineTransform(rotationAngle: angle)).concatenating(CGAffineTransform(scaleX: scale, y: scale))
            
        self.transform = transform!
        }
    
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimulattaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


