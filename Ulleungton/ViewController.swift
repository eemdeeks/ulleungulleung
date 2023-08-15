//
//  ViewController.swift
//  Ulleungton
//
//  Created by byo on 2023/08/15.
//

import Combine
import CoreMotion
import UIKit

final class ViewController: UIViewController {
	@IBOutlet weak var objectImageView: UIImageView!
	@IBOutlet weak var lineView: UIImageView!
	private let motionManager = CMMotionManager()
    private lazy var valueSmoother: FloatingValueSmoother = {
        FloatingValueSmoother(maxValuesCount: 10) { [unowned self] in
            updateRotation(of: objectImageView, angle: $0 * -1)
            updateRotation(of: lineView, angle: ($0 * -1) / 2)
        }
    }()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupMotionManager()
		setupImageView()
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
            valueSmoother.append(acceleration.x)
        }
    }
	
	private func setupImageView() {
		objectImageView.image = UIImage(named: "object")
		lineView.image = UIImage(named: "line")
        
        objectImageView.contentMode = .scaleAspectFill
        objectImageView.layer.anchorPoint = .init(x: 0.5, y: 1)
		lineView.center.x = objectImageView.center.x
	}
	
	private func updateRotation(of view: UIView, angle: CGFloat) {
		view.transform = .init(rotationAngle: angle)
	}
}
