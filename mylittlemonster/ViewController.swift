

import UIKit
import AVFoundation

class ViewController: UIViewController {

   
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var groundImg: UIImageView!
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var livesPanel: UIImageView!
    @IBOutlet weak var pickMonsterLbl: UILabel!
    @IBOutlet weak var pickMonster2: UIButton!
    @IBOutlet weak var pickMonster1: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var monsterUsing: Int = 1
    
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideEverything()
        
        restartBtn.hidden = true
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            let resourcePath = NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        
    }
   
    @IBAction func choiceMonster1(sender: AnyObject) {
        
        monsterUsing = 1
        
        monsterImg.hidden = false
        visibleEverything()
        hideStartScreen()
        
        restartGame()
        
        
    }
    @IBAction func choiceMonster2(sender: AnyObject) {
        monsterUsing = 2
       
        monsterImg.hidden = false
        visibleEverything()
        hideStartScreen()
        
        restartGame()
        
        
    }
    func hideStartScreen() {
        pickMonsterLbl.hidden = true
        pickMonster1.hidden = true
        pickMonster2.hidden = true
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
    }

    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation(monsterUsing)
        sfxDeath.play()
        restartBtn.hidden = false
    }
    
    func restartGame() {
        penalties = 0
        startTimer()
        monsterHappy = false
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        monsterImg.playIdleAnimation(monsterUsing)
        }
    func startScreen() {
        backGround.hidden = false
        groundImg.hidden = false
        pickMonsterLbl.hidden = false
        pickMonster1.hidden = false
        pickMonster2.hidden = false
        
        
    }
    func visibleEverything(){
        
        foodImg.hidden = false
        heartImg.hidden = false
        penalty1Img.hidden = false
        penalty2Img.hidden = false
        penalty3Img.hidden = false
        
        groundImg.hidden = false
        backGround.hidden = false
        livesPanel.hidden = false
    }
    func hideEverything() {
        monsterImg.hidden = true
        foodImg.hidden = true
        heartImg.hidden = true
        penalty1Img.hidden = true
        penalty2Img.hidden = true
        penalty3Img.hidden = true
        restartBtn.hidden = true
        groundImg.hidden = true
        backGround.hidden = true
        livesPanel.hidden = true
        
    }

    @IBAction func restartGameBtn(sender: AnyObject) {
        restartGame()
        restartBtn.hidden = true
    }

}

