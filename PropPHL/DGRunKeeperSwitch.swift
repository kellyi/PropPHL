//
//  DGRunkeeperSwitch.swift
//  DGRunkeeperSwitchExample
//
//  Created by Danil Gontovnik on 9/3/15.
//  Copyright © 2015 Danil Gontovnik. All rights reserved.
//
// https://github.com/gontovnik/DGRunkeeperSwitch
// https://github.com/gontovnik/DGRunkeeperSwitch/blob/master/LICENSE

import UIKit

// MARK: -
// MARK: DGRunkeeperSwitchRoundedLayer

class DGRunkeeperSwitchRoundedLayer: CALayer {
    
    override var frame: CGRect {
        didSet { cornerRadius = bounds.height / 2.0 }
    }
    
}

// MARK: -
// MARK: DGRunkeeperSwitch

class DGRunkeeperSwitch: UIControl {
    
    // MARK: -
    // MARK: Public vars
    
    var leftTitle: String {
        set { (leftTitleLabel.text, selectedLeftTitleLabel.text) = (newValue, newValue) }
        get { return leftTitleLabel.text! }
    }
    
    var rightTitle: String {
        set { (rightTitleLabel.text, selectedRightTitleLabel.text) = (newValue, newValue) }
        get { return rightTitleLabel.text! }
    }
    
    private(set) var selectedIndex: Int = 0
    
    var selectedBackgroundInset: CGFloat = 2.0 {
        didSet { setNeedsLayout() }
    }
    
    var selectedBackgroundColor: UIColor! {
        set { selectedBackgroundView.backgroundColor = newValue }
        get { return selectedBackgroundView.backgroundColor }
    }
    
    var titleColor: UIColor! {
        set { (leftTitleLabel.textColor, rightTitleLabel.textColor) = (newValue, newValue) }
        get { return leftTitleLabel.textColor }
    }
    
    var selectedTitleColor: UIColor! {
        set { (selectedLeftTitleLabel.textColor, selectedRightTitleLabel.textColor) = (newValue, newValue) }
        get { return selectedLeftTitleLabel.textColor }
    }
    
    var titleFont: UIFont! {
        set { (leftTitleLabel.font, rightTitleLabel.font, selectedLeftTitleLabel.font, selectedRightTitleLabel.font) = (newValue, newValue, newValue, newValue) }
        get { return leftTitleLabel.font }
    }
    
    var animationDuration: NSTimeInterval = 0.3
    var animationSpringDamping: CGFloat = 0.75
    var animationInitialSpringVelocity: CGFloat = 0.0
    
    // MARK: -
    // MARK: Private vars
    
    private var titleLabelsContentView = UIView()
    private var leftTitleLabel = UILabel()
    private var rightTitleLabel = UILabel()
    
    private var selectedTitleLabelsContentView = UIView()
    private var selectedLeftTitleLabel = UILabel()
    private var selectedRightTitleLabel = UILabel()
    
    private(set) var selectedBackgroundView = UIView()
    
    private var titleMaskView: UIView = UIView()
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    
    private var initialSelectedBackgroundViewFrame: CGRect?
    
    // MARK: -
    // MARK: Constructors
    
    init(leftTitle: String!, rightTitle: String!) {
        super.init(frame: CGRect.zero)
        
        self.leftTitle = leftTitle
        self.rightTitle = rightTitle
        
        finishInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        finishInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        finishInit()
    }
    
    private func finishInit() {
        // Setup views
        titleLabelsContentView.addSubview(leftTitleLabel)
        titleLabelsContentView.addSubview(rightTitleLabel)
        addSubview(titleLabelsContentView)
        
        object_setClass(selectedBackgroundView.layer, DGRunkeeperSwitchRoundedLayer.self)
        addSubview(selectedBackgroundView)
        
        selectedTitleLabelsContentView.addSubview(selectedLeftTitleLabel)
        selectedTitleLabelsContentView.addSubview(selectedRightTitleLabel)
        addSubview(selectedTitleLabelsContentView)
        
        (leftTitleLabel.textAlignment, rightTitleLabel.textAlignment, selectedLeftTitleLabel.textAlignment, selectedRightTitleLabel.textAlignment) = (.Center, .Center, .Center, .Center)
        
        object_setClass(titleMaskView.layer, DGRunkeeperSwitchRoundedLayer.self)
        titleMaskView.backgroundColor = .blackColor()
        selectedTitleLabelsContentView.layer.mask = titleMaskView.layer
        
        // Setup defaul colors
        backgroundColor = .blackColor()
        selectedBackgroundColor = .whiteColor()
        titleColor = .whiteColor()
        selectedTitleColor = .blackColor()
        
        // Gestures
        tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
        addGestureRecognizer(tapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        addObserver(self, forKeyPath: "selectedBackgroundView.frame", options: .New, context: nil)
    }
    
    // MARK: -
    // MARK: Destructor
    
    deinit {
        removeObserver(self, forKeyPath: "selectedBackgroundView.frame")
    }
    
    // MARK: -
    // MARK: Observer
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "selectedBackgroundView.frame" {
            titleMaskView.frame = selectedBackgroundView.frame
        }
    }
    
    // MARK: -
    
    override class func layerClass() -> AnyClass {
        return DGRunkeeperSwitchRoundedLayer.self
    }
    
    func tapped(gesture: UITapGestureRecognizer!) {
        let location = gesture.locationInView(self)
        if location.x < bounds.width / 2.0 {
            setSelectedIndex(0, animated: true)
        } else {
            setSelectedIndex(1, animated: true)
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer!) {
        if gesture.state == .Began {
            initialSelectedBackgroundViewFrame = selectedBackgroundView.frame
        } else if gesture.state == .Changed {
            var frame = initialSelectedBackgroundViewFrame!
            frame.origin.x += gesture.translationInView(self).x
            frame.origin.x = max(min(frame.origin.x, bounds.width - selectedBackgroundInset - frame.width), selectedBackgroundInset)
            selectedBackgroundView.frame = frame
        } else if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {
            let velocityX = gesture.velocityInView(self).x
            
            if velocityX > 500.0 {
                setSelectedIndex(1, animated: true)
            } else if velocityX < -500.0 {
                setSelectedIndex(0, animated: true)
            } else if selectedBackgroundView.center.x >= bounds.width / 2.0 {
                setSelectedIndex(1, animated: true)
            } else if selectedBackgroundView.center.x < bounds.size.width / 2.0 {
                setSelectedIndex(0, animated: true)
            }
        }
    }
    
    func setSelectedIndex(selectedIndex: Int, animated: Bool) {
        self.selectedIndex = selectedIndex
        if animated {
            UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: animationSpringDamping, initialSpringVelocity: animationInitialSpringVelocity, options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut], animations: { () -> Void in
                self.layoutSubviews()
                }, completion: { (finished) -> Void in
                    if finished {
                        self.sendActionsForControlEvents(.ValueChanged)
                    }
            })
        } else {
            layoutSubviews()
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    // MARK: -
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let selectedBackgroundWidth = bounds.width / 2.0 - selectedBackgroundInset * 2.0
        selectedBackgroundView.frame = CGRect(x: selectedBackgroundInset + CGFloat(selectedIndex) * (selectedBackgroundWidth + selectedBackgroundInset * 2.0), y: selectedBackgroundInset, width: selectedBackgroundWidth, height: bounds.height - selectedBackgroundInset * 2.0)
        
        (titleLabelsContentView.frame, selectedTitleLabelsContentView.frame) = (bounds, bounds)
        
        let titleLabelMaxWidth = bounds.width / 2.0 - selectedBackgroundInset * 2.0
        let titleLabelMaxHeight = bounds.height - selectedBackgroundInset * 2.0
        
        let leftTitleLabelSize = leftTitleLabel.sizeThatFits(CGSize(width: titleLabelMaxWidth, height: titleLabelMaxHeight))
        let leftTitleLabelOrigin = CGPoint(x: floor((bounds.width / 2.0 - leftTitleLabelSize.width) / 2.0), y: floor((bounds.height - leftTitleLabelSize.height) / 2.0))
        let leftTitleLabelFrame = CGRect(origin: leftTitleLabelOrigin, size: leftTitleLabelSize)
        (leftTitleLabel.frame, selectedLeftTitleLabel.frame) = (leftTitleLabelFrame, leftTitleLabelFrame)
        
        let rightTitleLabelSize = rightTitleLabel.sizeThatFits(CGSize(width: titleLabelMaxWidth, height: titleLabelMaxHeight))
        let rightTitleLabelOrigin = CGPoint(x: floor(bounds.size.width / 2.0 + (bounds.width / 2.0 - rightTitleLabelSize.width) / 2.0), y: floor((bounds.height - rightTitleLabelSize.height) / 2.0))
        let rightTitleLabelFrame = CGRect(origin: rightTitleLabelOrigin, size: rightTitleLabelSize)
        (rightTitleLabel.frame, selectedRightTitleLabel.frame) = (rightTitleLabelFrame, rightTitleLabelFrame)
    }
    
}

// MARK: -
// MARK: UIGestureRecognizer Delegate

extension DGRunkeeperSwitch: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return selectedBackgroundView.frame.contains(gestureRecognizer.locationInView(self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
}
