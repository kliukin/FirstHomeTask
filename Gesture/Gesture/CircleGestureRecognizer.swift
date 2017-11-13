import UIKit
import UIKit.UIGestureRecognizerSubclass

final class CircleGestureRecognizer: UIGestureRecognizer {

    // MARK: - Private properties

    private var midPoint = CGPoint.zero
    private var innerRadius: CGFloat?
    private var outerRadius: CGFloat?
    private var currentPoint: CGPoint?
    private var previousPoint: CGPoint?

    // MARK: - Public properties

    public var rotation: CGFloat? {
        guard let currentPoint = currentPoint, let previousPoint = previousPoint else {
            return nil
        }

        var rotation = angleBetween(pointA: currentPoint, andPointB: previousPoint)

        if rotation > CGFloat.pi {
            rotation -= CGFloat.pi * 2
        } else if rotation < -CGFloat.pi {
            rotation += CGFloat.pi * 2
        }
        return rotation
    }

    public var distance: CGFloat? {
        guard let nowPoint = currentPoint else {
            return nil
        }
        return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
    }

    // MARK: - Initialization

    init(midPoint: CGPoint, innerRadius: CGFloat?, outerRadius: CGFloat?, target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)

        self.midPoint = midPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
    }

    convenience init(midPoint: CGPoint, target: AnyObject?, action: Selector) {
        self.init(midPoint: midPoint, innerRadius: nil, outerRadius: nil, target: target, action: action)
    }

    // MARK: - Public methods

    public func distanceBetween(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }

    public func angleForPoint(point: CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + CGFloat.pi/2

        if angle < 0 {
            angle += CGFloat.pi * 2
        }
        return angle
    }

    public func angleBetween(pointA: CGPoint, andPointB pointB: CGPoint) -> CGFloat {
        return angleForPoint(point: pointA) - angleForPoint(point: pointB)
    }

    // MARK: - GestureRecognizer methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        if let firstTouch = touches.first {

            currentPoint = firstTouch.location(in: self.view)

            var newState: UIGestureRecognizerState = .began

            if let innerRadius = self.innerRadius, let distance = self.distance {
                if distance < innerRadius {
                    newState = .failed
                }
            }

            if let outerRadius = self.outerRadius, let distance = self.distance {
                if distance > outerRadius {
                    newState = .failed
                }
            }
            state = newState
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if state == .failed {
            return
        }

        if let firstTouch = touches.first {

            currentPoint = firstTouch.location(in: self.view)
            previousPoint = firstTouch.previousLocation(in: self.view)

            state = .changed
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended

        currentPoint = nil
        previousPoint = nil
    }
}
