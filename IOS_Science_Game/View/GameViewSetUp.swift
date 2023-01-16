/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class GameViewSetUp
{
    private let parentView: GameViewController
    private let bloodTypesGridView: MyViewCollection
    private let gameSceneView: SceneViewController
    
    init(parentView: GameViewController, gridView: MyViewCollection, gameSceneView: SceneViewController)
    {
        self.parentView = parentView
        self.bloodTypesGridView = gridView
        self.gameSceneView = gameSceneView
        setUp_GridView()
        setUp_GameScene()
        setUp_TopBar()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    }
    
    // ################################ Game View Sections Configration ###############################
    
    private func setUp_GridView()
    {
        //Add specfied view controller object as child of current view controller
        parentView.addChild(bloodTypesGridView)
        //Add the view of the view controller
        parentView.view.addSubview(bloodTypesGridView.view)
        //Let the child view know it has been moved into a parent view
        bloodTypesGridView.didMove(toParent: parentView)
        setUp_GridView_Constraints()
    }

    private func setUp_TopBar()
    {
        parentView.txt_question.text = "0 out of 8"
        parentView.txt_question.font = UIFont(name: "MarkerFelt-Thin", size: 28)
        parentView.txt_question.textColor = .red
        parentView.txt_question.textAlignment = .center
        let widther = CGFloat(300.0)
        let xPos = (parentView.view.frame.height - widther) / 2
        parentView.txt_question.frame = CGRect(x: xPos, y: 5, width: widther, height: 50)
        parentView.view.addSubview(parentView.txt_question)
        
        parentView.menuButton.setImage(UIImage(named: "optionMenu.png"), for: .normal)
        parentView.menuButton.frame = CGRect(x: parentView.view.frame.height - 90, y: 4, width: 55, height: 40)
        parentView.view.addSubview(parentView.menuButton)
        
        
        // ######## Next Question Button ########
        parentView.nextQuestionButton.frame = CGRect(x: 20, y: 5, width: 55, height: 40)
        parentView.nextQuestionButton.setBackgroundImage(UIImage(named: "button.png"), for: .normal)
        //parentView.nextQuestionButton.setTitle(title: "Next", for: .normal)
        parentView.nextQuestionButton.setTitle("Next", for: .normal)

        parentView.view.addSubview(parentView.nextQuestionButton)
    }
    
    private func setUp_GameScene()
    {
        //Add specfied view controller object as child of current view controller
        parentView.addChild(gameSceneView)
        //Add the view of the view controller
        parentView.view.addSubview(gameSceneView.view)
        //Let the child view know it has been moved into a parent view
        gameSceneView.didMove(toParent: parentView)
        setUp_GameScene_Constraints()
    }
    
    // ################################ View Constraints Configration ###############################
    
    private func setUp_GridView_Constraints()
    {
        bloodTypesGridView.view.translatesAutoresizingMaskIntoConstraints = false
        //bloodTypesGridView.view.trailingAnchor.constraint(equalTo: parentView.view.trailingAnchor).isActive = true
        //bloodTypesGridView.view.leadingAnchor.constraint(equalTo: parentView.view.leadingAnchor).isActive = true
        bloodTypesGridView.view.topAnchor.constraint(equalTo: parentView.view.topAnchor, constant: 50).isActive = true
        //###### Set Width and Height
        bloodTypesGridView.view.heightAnchor.constraint(equalTo: parentView.view.heightAnchor, multiplier: 0.26).isActive = true
        bloodTypesGridView.view.widthAnchor.constraint(equalTo: parentView.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        bloodTypesGridView.view.centerXAnchor.constraint(equalTo: parentView.view.centerXAnchor).isActive = true
    }
    
    private func setUp_GameScene_Constraints()
    {
        gameSceneView.view.translatesAutoresizingMaskIntoConstraints = false
        gameSceneView.view.bottomAnchor.constraint(equalTo: parentView.view.bottomAnchor).isActive = true
        gameSceneView.view.topAnchor.constraint(equalTo: bloodTypesGridView.view.bottomAnchor).isActive = true
        //###### Set Width and Height
        gameSceneView.view.heightAnchor.constraint(equalTo: parentView.view.heightAnchor, multiplier: 0.62).isActive = true
        gameSceneView.view.widthAnchor.constraint(equalTo: parentView.view.widthAnchor).isActive = true
    }
}
