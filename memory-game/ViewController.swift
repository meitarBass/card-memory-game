import UIKit

class ViewController: UIViewController {
    
    var cardsInfo = [CardInfo]()
    var cardViews = [CardView]()
    var timer: Timer!
    
    var flippedCards = [CardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createCards(cardsAmount: 4 * 3) //TODO: Change to constants
        addCardsToView(rows: 4, columns: 3)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            self.flipAllCards()
            self.timer.invalidate()
        })
    }
    
    func createCards(cardsAmount: Int) {
        var pairID = 0
        
        for num in 0 ..< cardsAmount {
            let cardInfo = CardInfo(pairID: pairID, frontText: "\(num + 1)", backText: "", isFlipped: true)
            
            // TODO: Get card info from file and add to array
            cardsInfo.append(cardInfo)
            
            if num % 2 == 1 {
                pairID += 1
            }
        }
        
        cardsInfo.shuffle()
    }
    
    func addCardsToView(rows: Int, columns: Int) {
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
                
                let cardView = CardView(frame: CGRect(x: xPosition, y: yPosition, width: cardWidth, height: cardHeight), info: cardsInfo[3 * row + col])
                
                makeCardTappable(card: cardView)
                
                
                scrollView.addSubview(cardView)
                cardViews.append(cardView)
                
                // To figure out the scrollView height
                contentHeight = yPosition + cardHeight + padding
            }
        }
        
        cardViews.shuffle()
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    func makeCardTappable(card: CardView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true
    }
    
    @objc func flipCard(_ sender: UITapGestureRecognizer) {
        if let card = sender.view as? CardView {
            card.flipCard()
            flippedCards.append(card)
            
            if flippedCards.count == 2 {
                checkIsPair()
            }
        }
    }
    
    func checkIsPair() {
        if flippedCards[0].info.pairID == flippedCards[1].info.pairID {
            print("pair")
            // remove from array of cards so we can't flip anymore
            flippedCards.removeAll()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.flippedCards[0].flipCard()
                self.flippedCards[1].flipCard()
                self.flippedCards.removeAll()
                self.enableAllCards()
            }
            disableAllCards()
        }
    }
    
    func disableAllCards() {
        for card in cardViews {
            card.isUserInteractionEnabled = false
        }
    }
    
    func enableAllCards() {
        for card in cardViews {
            card.isUserInteractionEnabled = true
        }
    }
    
    func flipAllCards() {
        for card in self.cardViews {
            card.flipCard()
        }
    }
}

