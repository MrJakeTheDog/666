import UIKit

class MenuVC : UIViewController {

    //MARK: - @IBActions
    @IBAction func online(_ sender: UIButton) {
        moveToGameVC(game: .online)
    }

    @IBAction func player2(_ sender: Any) {
        moveToGameVC(game: .player2)
    }

    @IBAction func offline(_ sender: Any) {
        moveToGameVC(game: .offline)
    }
    
    //MARK: - Custom
    func moveToGameVC(game : GameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        gameType = game
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}
