import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTapped(_ sender: gameButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameVC") as? GameViewController {
            switch sender.tag {
            case 0:
                vc.level = Level.easy
            case 1:
                vc.level = Level.medium
            case 2:
                vc.level = Level.hard
            default:
                return
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
