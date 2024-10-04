import UIKit

class CardView: UIView {
    
    var cornerRadius: CGFloat = 10.0
    
    var cardBackColor: UIColor = .orange
    var cardFrontColor: UIColor = .white
    
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 2.0

    var info: CardInfo!
    
    init(frame: CGRect, info: CardInfo) {
        super.init(frame: frame)
        self.info = info
        setupCard()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCard() {
        renderCard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
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
                   
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]
                   
            let textRect = CGRect(x: 0, y: size.height / 2 - 20, width: size.width, height: 40)
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
