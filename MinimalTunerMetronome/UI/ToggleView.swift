import UIKit

class ToggleView: UIButton {
    
    let knobImageView = UIImageView(image: UIImage(named: "toggle_knob"))
    let knobAspectRatio = CGFloat(1.18)
    let knobHeightProportionToViewHeight = CGFloat(0.65)
    let knobLeadingMarginProportionToViewWidth = CGFloat(0.085)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpKnobConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpKnobConstraints()
    }
    
    func setUpKnobConstraints() {
        knobImageView.frame.size.height = frame.height * knobHeightProportionToViewHeight
        knobImageView.frame.size.width = knobImageView.frame.size.height * knobAspectRatio
        knobImageView.frame.origin.x = frame.width * knobLeadingMarginProportionToViewWidth
        knobImageView.frame.origin.y = (frame.height - knobImageView.frame.height) * 0.5
        addSubview(knobImageView)
    }
}
