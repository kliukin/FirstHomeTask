import UIKit

extension CGFloat {
    var degrees: CGFloat {
        return self * 180 / piValue
    }
    var radians: CGFloat {
        return self * piValue / 180
    }
    var rad2deg: CGFloat {
        return degrees
    }
    var deg2rad: CGFloat {
        return radians
    }
}
