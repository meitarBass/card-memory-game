import UIKit

enum Level: String {
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
}

class GameViewController: UIViewController {
        
    @IBOutlet var difficultyLevel: UILabel!
    @IBOutlet var playerOneLabel: UILabel!
    @IBOutlet var playerTwoLabel: UILabel!
    
    @IBOutlet var playerOneScoreLabel: UILabel!
    @IBOutlet var playerTwoScoreLabel: UILabel!
    
    var level: Level?
        
    var playerOneScore = 0 {
        didSet {
            playerOneScoreLabel.text = "score: \(playerOneScore)"
        }
    }
    
    var playerTwoScore = 0 {
        didSet {
            playerTwoScoreLabel.text = "score: \(playerTwoScore)"
        }
    }
    
    @IBOutlet var cardsScrollView: UIScrollView!
    
    var cardsInfo = [CardInfo]()
    var cardViews = [CardView]()
    var timer: Timer!
    
    var flippedCards = [CardView]()
    var isPlayerOneTurn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createCards(cardsAmount: 4 * 3) //TODO: Change to constants
        addCardsToView(rows: 4, columns: 3)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            self.flipAllCards()
            self.timer.invalidate()
        })
        
        guard let level = level else { return }
        difficultyLevel.text = "\(level.rawValue)"
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
        // Calculate the size of each card based on the screen size
        let padding: CGFloat = 20
        let cardWidth = (view.frame.width - padding * CGFloat(columns + 1)) / CGFloat(columns)
        let cardHeight = cardWidth * 1.5
        
        var contentHeight: CGFloat = 0
        
        for row in 0..<rows {
            for col in 0..<columns {
                let xPosition = padding + CGFloat(col) * (cardWidth + padding)
                let yPosition = padding + CGFloat(row) * (cardHeight + padding) // 100 for top margin
                
                let cardView = CardView(frame: CGRect(x: xPosition, y: yPosition, width: cardWidth, height: cardHeight), info: cardsInfo[3 * row + col])
                
                makeCardTappable(card: cardView)
                
                
                cardsScrollView.addSubview(cardView)
                cardViews.append(cardView)
                
                // To figure out the scrollView height
                contentHeight = yPosition + cardHeight + padding
            }
        }
        
        cardViews.shuffle()
        cardsScrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
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
            if isPlayerOneTurn {
                playerOneScore += 1
            }  else {
                playerTwoScore += 1
                
            }
            // remove from array of cards so we can't flip anymore
            flippedCards.removeAll()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.flippedCards[0].flipCard()
                self.flippedCards[1].flipCard()
                self.flippedCards.removeAll()
                self.enableAllCards()
                self.isPlayerOneTurn.toggle()
                self.flipColors()
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
    
    func flipColors() {
        playerOneLabel.textColor = isPlayerOneTurn ? .systemRed : .black
        playerTwoLabel.textColor = isPlayerOneTurn ? .black : .systemRed
    }
}

