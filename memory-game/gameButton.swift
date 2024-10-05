import UIKit

class gameButton: UIButton {
    
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
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.backgroundColor = .orange
        self.clipsToBounds = true
        
        // Change font
        self.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)
    }
}
