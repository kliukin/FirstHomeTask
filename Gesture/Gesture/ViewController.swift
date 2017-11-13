import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var circleImageView: UIImageView!

    private var isSegueInProcess = false
    private var innerRadius: CGFloat {
        return circleImageView.frame.width / 3
    }
    private var outerRadius: CGFloat {
        return circleImageView.frame.width / 2
    }
    private var center: CGPoint {
        return circleImageView.center
    }
    private var currentValue: CGFloat = 0.0 {
        didSet {
            if currentValue > 100 {
                currentValue = 100
            }
            if currentValue < 0 {
                currentValue = 0
            }
        }
    }
    private var circleRecognizer: CircleGestureRecognizer {
        return CircleGestureRecognizer(midPoint: center,
                                       innerRadius: innerRadius,
                                       outerRadius: outerRadius,
                                       target: self,
                                       action: #selector(circleGesture))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        view.addGestureRecognizer(circleRecognizer)
    }

    @objc func circleGesture(recognizer: CircleGestureRecognizer) {
        if recognizer.rotation == nil {
            currentValue = 0
        }

        if let rotation = recognizer.rotation {
            currentValue += rotation.degrees / 360 * 100
            print("value: \(currentValue)")
        }

        if currentValue == 100.0 {
            if !isSegueInProcess {
                performSegue(withIdentifier: "Show Tab Bar", sender: self)
                isSegueInProcess = true
            }
        }
    }
}
