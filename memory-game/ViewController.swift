import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createCard()
    }
    
    func createCard() {
        let info = CardInfo(id: "1", frontText: "front", backText: "back", isFlipped: false)
        let cardView = CardView(frame: CGRect(x: 50, y: 100, width: 100, height: 150), info: info)
        cardView.renderCard()
        
        view.addSubview(cardView)
    }


}

