//
//  ViewController.swift
//  Ruler
//
//  Created by Kryg Tomasz on 07.09.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var measureButton: UIButton! {
        didSet {
            self.measureButton.isEnabled = false
            measureButton.setTitle("", for: .normal)
            measureButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
            measureButton.tintColor = .mainGreen
            measureButton.addTarget(self, action: #selector(onMeasureButtonClicked), for: .touchUpInside)
        }
    }
    @IBOutlet weak var aimView: UIView! {
        didSet {
            aimView.layer.cornerRadius = aimView.bounds.width/2
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.text = ""
            distanceLabel.layer.borderWidth = 1
            distanceLabel.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = "Wait for calibration..."
            infoLabel.layer.borderWidth = 1
            infoLabel.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var isMeasuring: Bool = false {
        didSet {
            if isMeasuring {
                measureButton.setImage(#imageLiteral(resourceName: "pauseIcon"), for: .normal)
                measureButton.tintColor = .mainRed
            } else {
                startPosition = nil
                measureButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
                measureButton.tintColor = .mainGreen
            }
        }
    }
    
    var startPosition: SCNVector3?
    var endPosition: SCNVector3?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            let centerPoint = self.view.center
            let hitResults = self.sceneView.hitTest(centerPoint, types: [.featurePoint])
            if let hitResult = hitResults.first {
                self.infoLabel.isHidden = true
                self.measureButton.isEnabled = true
                if self.isMeasuring {
                    let worldHitTransform = SCNMatrix4(hitResult.worldTransform)
                    let worldHitPosition = SCNVector3Make(worldHitTransform.m41, worldHitTransform.m42, worldHitTransform.m43)
                    self.updateDistance(using: worldHitPosition)
                }
            }
        }
    }
    
    func updateDistance(using position: SCNVector3?) {
        guard let start = startPosition else {
            resetMeasurements()
            startPosition = position
            return
        }
        endPosition = position
        guard let end = endPosition else {
            return
        }
        
        let cmDistance = start.distance(from: end) * 100
        distanceLabel.text = String(format: "%.2f cm", cmDistance)
    }
    
    func resetMeasurements() {
        
    }
    
    @objc func onMeasureButtonClicked() {
        
        isMeasuring = !isMeasuring
        
    }

}