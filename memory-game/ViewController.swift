import UIKit

class ViewController: UIViewController {
    
    var cardViews = [CardView]()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createCards(rows: 3, columns: 3)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            self.flipAllCards()
            self.timer.invalidate()
        })
    }
    
    func createCards(rows: Int, columns: Int) {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        // Calculate the size of each card based on the screen size
        let padding: CGFloat = 20
        let cardWidth = (view.frame.width - padding * CGFloat(columns + 1)) / CGFloat(columns)
        let cardHeight = cardWidth * 1.5
        
        var contentHeight: CGFloat = 0
        
        for row in 0..<rows {
            for col in 0..<columns {
                let xPosition = padding + CGFloat(col) * (cardWidth + padding)
                let yPosition = padding + CGFloat(row) * (cardHeight + padding) + 100 // 100 for top margin
                
                // TODO: Get card info from file and add to array
                let cardView = CardView(frame: CGRect(x: xPosition, y: yPosition, width: cardWidth, height: cardHeight), info: CardInfo(pairID: "", frontText: "\(3 * row + (col + 1))", backText: "", isFlipped: true))
                
                scrollView.addSubview(cardView)
                cardViews.append(cardView)
                
                // To figure out the scrollView height
                contentHeight = yPosition + cardHeight + padding
            }
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    func flipAllCards() {
        for card in self.cardViews {
            card.flipCard()
        }
    }
}

