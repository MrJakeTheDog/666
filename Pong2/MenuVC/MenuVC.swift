import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var online: UIButton!
    @IBOutlet weak var status: UILabel!
    // MARK: - @IBActions
    @IBAction func online(_ sender: UIButton) {
        moveToGameVC(game: .online)
    }

    @IBAction func player2(_ sender: UIButton) {
        moveToGameVC(game: .player2)
    }

    @IBAction func offline(_ sender: UIButton) {
        moveToGameVC(game: .offline)
    }

    // MARK: - Custom
    func moveToGameVC(game: GameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as? GameViewController
        gameType = game
        self.navigationController?.pushViewController(gameVC ?? GameViewController(), animated: true)
    }

    override func viewDidLoad() {
        if  Internet.connection() == false {
            online.isEnabled = false
            status.text = "No internet connection"
        } else {
            online.isEnabled = true
            status.text = "Internet is connected"
        }
    }
}
