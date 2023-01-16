/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit
import SpriteKit

/**
 *This class is responsible to initiate the game scene area.
 */
class SceneViewController: UIViewController
{
    private var scene: MainScene? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let skView = SKView()
        skView.bounds.size = view.bounds.size
        view = skView
        let skview = view as! SKView
        scene = MainScene(size: skView.bounds.size)
        scene!.scaleMode = .resizeFill
        skview.presentScene(scene)
        //Assign the scene as reciver to the accelerometer feed of data.
        _ = AccelerometerController(mainScene: scene!)
    }
    
    public func getGameScene() -> MainScene
    {
        return scene!
    }
}
