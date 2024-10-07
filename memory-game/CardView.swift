import UIKit

class CardView: UIView {
    
    var cornerRadius: CGFloat = 10.0
    
    var cardBackColor: UIColor = .orange
    var cardFrontColor: UIColor = .white
    
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 3.0

    var info: CardInfo!
    var textLabel: UILabel!
    var imageView: UIImageView!
    
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
        setupLabel()
        renderCard()
        
        // Add shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.55
        self.layer.shadowOffset = CGSize(width: 8, height: 4)
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
    
    private func setupLabel() {
        textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        
        let fontSize: CGFloat = useBigFont ? (info.frontText.count > 3 ? 24 : 54) : (info.frontText.count > 3 ? 14 : 36)
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        
        textLabel.text = info.isFlipped ? info.frontText : info.backText
        
        textLabel.frame = CGRect(x: 10, y: self.bounds.height / 2 - 20, width: self.bounds.width - 20, height: 40)
    }
    
    func renderCard() {
        let text = info.isFlipped ? info.frontText : info.backText
        let color = info.isFlipped ? cardFrontColor : cardBackColor
        
        let cardSize = self.bounds.size
        let cardImage = drawCard(withText: text, size: cardSize, color: color)
        
        imageView = UIImageView(image: cardImage)
        imageView.frame = self.bounds
    
        addSubview(imageView)
        guard let textLabel = self.textLabel else { return }
        addSubview(textLabel)
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
        }
        return img
    }
        
    @objc func flipCard() {
        info.isFlipped.toggle()
        
        textLabel.text = info.isFlipped ? info.frontText : info.backText
        
        UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromRight], animations: {
            guard let imageView = self.imageView else { return }
            guard let textLabel = self.textLabel else { return }
            
            imageView.removeFromSuperview()
            textLabel.removeFromSuperview()
            self.renderCard()
        })
    }
}
