import UIKit

extension CGAffineTransform {
    func rotation() -> CGFloat {
        return atan2(c, a)
    }
}
