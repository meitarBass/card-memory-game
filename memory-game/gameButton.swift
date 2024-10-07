import UIKit

class gameButton: UIButton {
    
    private var useBigFont = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // Change button appearance
        self.layer.cornerRadius = 20
        self.backgroundColor = .orange
        self.clipsToBounds = true
        
        
        // Add shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            useBigFont = true
        }
        
        // Change font
        if useBigFont {
            self.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 28)
        } else {
            self.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        }
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)
    }
}
