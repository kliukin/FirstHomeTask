import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var circleImage: UIImageView!

    private var isSegueInProcess = false
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let circleRecognizer = CircleGestureRecognizer(midPoint: circleImage.center,
                                                       innerRadius: circleImage.frame.height / 3,
                                                       outerRadius: circleImage.frame.height / 2,
                                                       target: self, action: #selector(circleGesture))

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
                self.performSegue(withIdentifier: "Show Tab Bar", sender: self)
                isSegueInProcess = true
            }
        }
    }
}
