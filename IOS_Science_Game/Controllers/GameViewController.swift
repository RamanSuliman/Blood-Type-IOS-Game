/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class GameViewController: UIViewController
{
    let menuButton = ButtonController()
    let nextQuestionButton = ButtonController()
    let txt_question = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .black
        let layout = UICollectionViewFlowLayout()
        let collectionViewer = MyViewCollection(collectionViewLayout: layout)
        
        let gameSceneView = SceneViewController()
        _ = GameViewSetUp(parentView: self, gridView: collectionViewer, gameSceneView: gameSceneView)
        _ = MainGameController(collectionViewCont: collectionViewer, gameScene: gameSceneView.getGameScene(), parentView: self)
    }
}
