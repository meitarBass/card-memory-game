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
    
    var totalFlippedCards = 0
    var useBigFont = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            useBigFont = true
        }
        
        createLevel()
        disableCards()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in
            self.flipAllCards()
            self.timer.invalidate()
            self.enableCards()
        })
        
        guard let level = level else { return }
        difficultyLevel.text = "\(level.rawValue)"
    }
    
    func createLevel() {
        var rows = 0, columns = 0
        
        switch level {
        case .easy:
            rows = 2
            columns = 3
        case .medium:
            rows = 4
            columns = 4
        case .hard:
            rows = 6
            columns = 3
        case nil:
            break
        }
        
        loadLevel()
        addCardsToView(rows: rows, columns: columns)
    }
        
    func addCardsToView(rows: Int, columns: Int) {
        // Calculate the size of each card based on the screen size
        let padding: CGFloat = 20
        let cardWidth = (view.frame.width - padding * CGFloat(columns + 1)) / CGFloat(columns)
        let cardHeight = cardWidth * 1.5
        
        var contentHeight: CGFloat = 0
        
        var counter = 0
        
        for row in 0..<rows {
            for col in 0..<columns {
                let xPosition = padding + CGFloat(col) * (cardWidth + padding)
                let yPosition = padding + CGFloat(row) * (cardHeight + padding) // 100 for top margin
                
                let cardView = CardView(frame: CGRect(x: xPosition, y: yPosition, width: cardWidth, height: cardHeight), info: cardsInfo[counter], useBigFont: useBigFont)
                counter += 1
                
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
            
            if flippedCards.count.isMultiple(of: 2) {
                checkIsPair()
            }
        }
    }
    
    func checkIsPair() {
        if flippedCards[totalFlippedCards].info.pairID == flippedCards[totalFlippedCards + 1].info.pairID {
            // TODO: Check if game finished, add who win and maybe refresh
            if isPlayerOneTurn {
                playerOneScore += 1
            }  else {
                playerTwoScore += 1
                
            }
            
            // disable cards
            flippedCards[totalFlippedCards].isUserInteractionEnabled = false
            flippedCards[totalFlippedCards + 1].isUserInteractionEnabled = false
            
            cardViews.removeAll(where: { $0.info.pairID == flippedCards[totalFlippedCards].info.pairID })
            
            if cardViews.isEmpty {
                createNewGame()
            }
            
            // add to counter
            totalFlippedCards += 2
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                
                // not a match - flip back
                self.flippedCards[totalFlippedCards].flipCard()
                self.flippedCards[totalFlippedCards + 1].flipCard()
                
                // remove from array
                self.flippedCards.remove(at: totalFlippedCards + 1) // count start at 0
                self.flippedCards.remove(at: totalFlippedCards)
                
                self.enableCards()
                self.isPlayerOneTurn.toggle()
                self.flipColors()
            }
            disableCards()
        }
    }
    
    func disableCards() {
        for card in cardViews {
            card.isUserInteractionEnabled = false
        }
    }
    
    func enableCards() {
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
    
    func loadLevel() {
        guard let level = level else { return }
        let randomFile = Int.random(in: 1...3)
        
        guard let levelURL = Bundle.main.url(forResource: "\(level.rawValue.lowercased())_\(randomFile)", withExtension: "txt") else {
            fatalError("Could not find the file in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        var paidID = 0
        
        for (index, line) in lines.enumerated() {
            if !line.isEmpty {
                cardsInfo.append(CardInfo(pairID: paidID, frontText: line, backText: "", isFlipped: true))
                if index % 2 == 1 {
                    paidID += 1
                }
            }
        }
        
        
        cardsInfo.shuffle()
    }
    
    func createNewGame() {
        let res = playerOneScore > playerTwoScore ? "Player 1 won" : playerOneScore == playerTwoScore ? "It's a tie" : "Player 2 won"
        let ac = UIAlertController(title: "\(res)", message: "Would you like to play another game?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if let navController = self.navigationController {
                if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "GameVC") as? GameViewController {
                    var viewControllers = navController.viewControllers
                    
                    newVC.level = self.level
                    viewControllers.removeLast()
                    viewControllers.append(newVC)
                    
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                }
            }
        }))
        
        present(ac, animated: true)
    }
}

