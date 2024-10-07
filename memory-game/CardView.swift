import UIKit

class CardView: UIView {
    
    var cornerRadius: CGFloat = 10.0
    
    var cardBackColor: UIColor = .orange
    var cardFrontColor: UIColor = .white
    
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 3.0

    var info: CardInfo!
    
    var useBigFont = false
    
    init(frame: CGRect, info: CardInfo, useBigFont: Bool) {
        super.init(frame: frame)
        self.info = info
        self.useBigFont = useBigFont
        setupCard()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCard() {
        renderCard()
        // Add shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.55
        self.layer.shadowOffset = CGSize(width: 8, height: 4)
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
    
    func renderCard() {
        let text = info.isFlipped ? info.frontText : info.backText
        let color = info.isFlipped ? cardFrontColor : cardBackColor
        
        let cardSize = self.bounds.size
        let cardImage = drawCard(withText: text, size: cardSize, color: color)
        
        let imageView = UIImageView(image: cardImage)
        imageView.frame = self.bounds
        imageView.tag = 100 // tagging to remove / replace old image later
        
        addSubview(imageView)
    }
    
    func drawCard(withText text: String, size: CGSize, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let img = renderer.image { ctx in
            
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            let path = UIBezierPath(roundedRect: rectangle, cornerRadius: cornerRadius)
            color.setFill()
            path.fill()
            
            
            borderColor.setStroke()
            path.lineWidth = borderWidth
            path.stroke()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            var fontSize: CGFloat
            var fontHeight: CGFloat = 40
            
            if useBigFont {
                fontHeight += 40
                if text.count > 3 {
                    fontSize = 32
                } else {
                    fontSize = 54
                }
            } else {
                if text.count > 3 {
                    fontSize = 12
                } else {
                    fontSize = 40
                }
            }
            
            
                   
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]
                   
            let textRect = CGRect(x: 0, y: size.height / 2 - 20, width: size.width, height: fontHeight)
            text.draw(in: textRect, withAttributes: attrs)
        }
        return img
    }
        
    @objc func flipCard() {
        info.isFlipped.toggle()
        
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromRight], animations: {
            self.viewWithTag(100)?.removeFromSuperview()
            self.renderCard()
        })
    }
}
