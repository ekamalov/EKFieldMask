//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Erik Kamalov <ekamalov967@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

open class TipView: UIView {
    // MARK: - Properties
    public struct Preferences {
        public struct Text {
            public var font: UIFont                     = UIFont(name: "Gilroy-SemiBold", size: 14) ?? .boldSystemFont(ofSize: 14)
            public var color: UIColor                   = .black
            public var contentInset: UIEdgeInsets       = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            public var textAlignment:NSTextAlignment    = NSTextAlignment.center
        }
        public struct Triangle {
            public var width: CGFloat  = 16
            public var height: CGFloat = 10
        }
        public struct Body {
            public var dismissOnTap: Bool        = true
            public var dismissTimerDelay: Double = 3

            public var backgroundColor: UIColor  = .white
            public var cornerRadius: CGFloat     = 5

            public var borderWidth: CGFloat      = 0
            public var borderColor: UIColor      = .clear
            
            public struct Shadow {
                public var color: UIColor = UIColor(red: 212.0 / 255.0, green: 217.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
                public var offset: CGSize = CGSize(width: 0, height: 0)
                public var blur: CGFloat  = 20
                public var opacity: Float = 1
            }
            public var shadow = Shadow()
        }
        public var text = Text()
        public var triangle = Triangle()
        public var body = Body()
        public init() {}
    }
    
    var text: String
    
    private(set) open var preferences: Preferences
    
    private lazy var contentSize: CGSize = { [unowned self] in
        var attributes = [NSAttributedString.Key.font : self.preferences.text.font]
        var textSize = text.boundingRect(with: CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size
        
        textSize.width = ceil(textSize.width) + preferences.text.contentInset.left + preferences.text.contentInset.right
        textSize.height = ceil(textSize.height) + preferences.triangle.height + preferences.text.contentInset.top + preferences.text.contentInset.bottom
        return textSize
        }()
    
    // MARK: - Life cycle
    init(text:String, preferences: Preferences) {
        self.text = text
        self.preferences = preferences
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
   public func show(view: UIView, animated: Bool = true, hasShadow:Bool = true) {
        let superView = view.findViewController()
        let viewFrame = view.globalFrame ?? view.frame
        
        self.frame = .init(origin: .init(x: viewFrame.midX - contentSize.width / 2, y: viewFrame.origin.y - contentSize.height), size: contentSize)
        
        transform = CGAffineTransform(scaleX: 0, y: 0)
        alpha = 0
        
        if hasShadow {
            self.layer.applySketchShadow(color: preferences.body.shadow.color, alpha: preferences.body.shadow.opacity,
                                         offset: preferences.body.shadow.offset, blur: preferences.body.shadow.blur)
        }
        
        superView?.view.addSubview(self)
        
        if animated {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                           options: [.curveEaseInOut], animations: {
                            self.transform = .identity
                            self.alpha = 1
            }) { _ in
                Timer.scheduledTimer(withTimeInterval: self.preferences.body.dismissTimerDelay, repeats: false) { _ in
                    self.dismiss()
                }
            }
        }
    }
    
   public func dismiss(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7,initialSpringVelocity: 0.7,
                       options: [.curveEaseInOut], animations: {
                        self.transform = CGAffineTransform(scaleX: 0, y: 0)
                        self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    // MARK: - Override methods
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if preferences.body.dismissOnTap { self.dismiss() }
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        makePath()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}

// MARK: - Extension private methods
extension TipView {
    private func makePath() {
        let rect = CGRect(x: preferences.body.borderWidth, y: preferences.body.borderWidth, width: self.bounds.width - preferences.body.borderWidth * 2,
                                                        height: self.bounds.height - preferences.body.borderWidth * 2 - preferences.triangle.height)
        let roundRectPath = UIBezierPath(roundedRect: rect, cornerRadius: preferences.body.cornerRadius)
        roundRectPath.close()
        addTriangle(to: roundRectPath)
        setColor(to: roundRectPath)
        drawText(to: roundRectPath)
    }
    
    private func addTriangle(to rect: UIBezierPath) {
        let x: CGFloat = rect.bounds.midX - preferences.triangle.width / 2
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: x, y: rect.bounds.maxY))
        trianglePath.addLine(to: CGPoint(x: x + preferences.triangle.width / 2, y: rect.bounds.maxY + preferences.triangle.height))
        trianglePath.addLine(to: CGPoint(x: x + preferences.triangle.width, y: rect.bounds.maxY))
        trianglePath.close()
        
        rect.append(trianglePath)
    }
    
    private func drawText(to rect: UIBezierPath){
        let paragraphStyle           = NSMutableParagraphStyle()
        paragraphStyle.alignment     = preferences.text.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let attributes: [NSAttributedString.Key: NSObject] = [ .font : preferences.text.font, .foregroundColor : preferences.text.color, .paragraphStyle : paragraphStyle]
        
        let rects:CGRect = .init(x: preferences.text.contentInset.left , y: preferences.text.contentInset.top,
                                 width: contentSize.width - (preferences.text.contentInset.left + preferences.text.contentInset.right),
                                 height: contentSize.height - (preferences.text.contentInset.top + preferences.text.contentInset.bottom))
        
        text.draw(in: rects, withAttributes: attributes)
    }
    private func setColor(to rect: UIBezierPath) {
        if preferences.body.borderWidth > 0 {
            preferences.body.borderColor.setStroke()
            rect.lineWidth = preferences.body.borderWidth
            rect.stroke()
        }
        
        preferences.body.backgroundColor.setFill()
        rect.fill()
    }
}
