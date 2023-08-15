//
//  ViewController.swift
//  Ulleungton
//
//  Created by byo on 2023/08/15.
//

import CoreMotion
import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var objectImageView: UIImageView!
    private let motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMotionManager()
        setupObjectImageView()
    }
    
    private func setupMotionManager() {
        guard motionManager.isAccelerometerAvailable else {
            return
        }
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: .main) { [unowned self] (data, error) in
            guard let acceleration = data?.acceleration else {
                return
            }
            updateRotation(
                of: objectImageView,
                angle: acceleration.x * -1
            )
        }
    }
    
    private func setupObjectImageView() {
        objectImageView.image = UIImage(named: "object")
    }
    
    private func updateRotation(of view: UIView, angle: CGFloat) {
        view.layer.anchorPoint = .init(x: 0.5, y: 1)
        view.transform = .init(rotationAngle: angle)
    }
}
