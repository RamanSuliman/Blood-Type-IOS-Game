/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class MainGameController
{
    private var list_of_collection_cells: [BloodTypeCell] = []
    private var bloodTypesImage:[BloodType]?
    private var currentBloodTypeTarget: String?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let gameScene: MainScene
    private let parentView: GameViewController
    
    init(collectionViewCont: MyViewCollection, gameScene: MainScene, parentView: GameViewController)
    {
        //Retrive the data module instance from AppDelegate.
        bloodTypesImage = appDelegate.dataModel.getBloodTypes()
        //Get the list of collection view cells that holds tables for blood type images.
        self.list_of_collection_cells = collectionViewCont.getCollectionViewCells()
        self.gameScene = gameScene
        //Setup the option menu button
        self.parentView = parentView
        setupCustomMenuButton(menuButton: parentView.menuButton)
        nextQuestionButtonEventHandler(nextQuestionButton: parentView.nextQuestionButton)
        gameScene.broadcastCollision = collisionDetected
    }
    
    private func collisionDetected() -> ()
    {
        let bloodTypeImage = gameScene.lastCollidedBloodType
        //Get the current assigned option blood type from the UI element to be inserted on collision.
        let row = retrunTargetRow(collidedBloodTypeName: bloodTypeImage!)
        addBloodTypeImageToTable(targetBloodTypeImage: (gameScene.bloodTypeOptionQuestion_txt?.text)!, targetRow: row)
    }
    
    private func addBloodTypeImageToTable(targetBloodTypeImage: String, targetRow: Int)
    {
        let tableCells = list_of_collection_cells[targetRow].getTableCells()
        print(targetBloodTypeImage)
        for cell in tableCells
        {
            let imageLeft = getImageName(targetImage: cell.getLeftIamge())
            let imageRight = getImageName(targetImage: cell.getRightIamge())
            if(imageLeft == "default" || imageRight == "default")
            {
                if(imageLeft == "default")
                {
                    cell.setLeftImage(image: UIImage(named: targetBloodTypeImage + ".png")!)
                    break
                }
                if(imageRight == "default")
                {
                    cell.setRightImage(image: UIImage(named: targetBloodTypeImage + ".png")!)
                    break
                }
            }
        }
    }
    
    // ################################ Set up Next Question Button Handler ###############################
    
    private func nextQuestionButtonEventHandler(nextQuestionButton: ButtonController)
    {
        nextQuestionButton.addAction(UIAction(handler: {_ in
            if self.gameScene.areQuestionEnded()
            {
                self.displayMessage(hasWon: self.checkWin())
            }
            else
            {
                self.gameScene.setNewBloodTypeOptionOnScreen()
                self.gameScene.roundAnsweresHashCollection.removeAll()
                self.parentView.txt_question.text = String(self.gameScene.questionAlreadyAsked.count) + " out of 8"
                if self.gameScene.areQuestionEnded()
                {
                    self.parentView.nextQuestionButton.setTitle("Results", for: .normal)
                }
            }
        }), for: .touchUpInside)
    }
    
    // ################################ Check Win ###############################
    
    private func checkWin() -> Bool
    {
        var numberOfCorrectAns = 0
        for i in 0...list_of_collection_cells.count - 1
        {
            let table = list_of_collection_cells[i].getTableCells()
            for cell in table
            {
                let imgOne = cell.getLeftIamge()
                let imgTwo = cell.getRightIamge()
                if compareTableCellWithAnswers(imgOne: imgOne, imgTwo: imgTwo, row: i)
                {
                    numberOfCorrectAns += 1
                }
            }
        }
        return (numberOfCorrectAns < 27) ? false : true
    }
    
    private func compareTableCellWithAnswers(imgOne: UIImage, imgTwo: UIImage, row: Int)-> Bool
    {
        //Get the blood type object corrsponding to the the row index.
        let bloodType = self.gameScene.optionBloodTypes![row]
        //Extraxt the images in the table row names.
        let imgOne = getImageName(targetImage: imgOne)
        let imgTwo = getImageName(targetImage: imgTwo)
        //Loop through the answers list of the blood type and compare it to the image names.
        for answer in bloodType.getCompatibleBloodTypes
        {
            if answer == imgOne || answer == imgTwo
            {
                return true
            }
        }
        return false
    }
    
    private func displayMessage(hasWon: Bool)
    {
        var title = ""
        var message = ""
        if(hasWon)
        {
            title = "VICTORY"
            message = "You have successfully managed to form a compatible grouping for each of blood types."
        }
        else
        {
            title = "Defeated"
            message = "Mission failed, you have to make sure blood types are allocated properly to avoid risking people lives."
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Retrun to menu", style: .default) { (action) in
            self.parentView.performSegue(withIdentifier: "MainMenu", sender: self.parentView)
        }
        //Handler can be set to nil if we only want to hide the alert no code to execute.
        //style: .cancel is a predefined action to cancel the alert.
        let actionAlertThree = UIAlertAction(title: "Leave", style: .destructive, handler: { (action) in
            exit(0)
        })
        
        //Add buttons into the alert
        alert.addAction(actionAlert)
        alert.addAction(actionAlertThree)
        
        //Show the alert, turn on animation
        parentView.present(alert, animated: true, completion: nil)
    }
    
    // ################################ Set up option menu ###############################
    
    private func setupCustomMenuButton(menuButton: ButtonController)
    {
        menuButton.showsMenuAsPrimaryAction = true
        //Change menu location
        menuButton.menu_location = CGPoint(x: 10, y: -5)
        menuButton.menu = UIMenu(title: "", children: [
            UIAction(title: "Touch & Drag", image: UIImage(systemName: "hand.tap")){ action in
                self.gameScene.typeOfInput = "tocuh_drag"
            },
            UIAction(title: "Accelerometer", image: UIImage(systemName: "ipodtouch.landscape")){ action in
                self.gameScene.typeOfInput = "Accelerometer"
            },
            UIAction(title: "Menu", image: UIImage(named: "optionMenu.png")){ action in
                self.parentView.performSegue(withIdentifier: "MainMenu", sender: self.parentView)

            },
            UIAction(title: "Exit", image: UIImage(systemName: "clear.fill")){ action in
                exit(0)
            }
        ])
    }
    
    // ################################ Image Filtering ###############################
    
    private func getImageName(targetImage: UIImage)-> String
    {
        //Get the target image description which contains the image name.
        let imageDescription = targetImage.description
        //Define the regular expression pattern that gets the image.
        let patternRule = "\\([a-zA-Z(\\+|\\-)]+.[a-z]+\\)"
        //Apply the pattern to matches() with the image descrption to return the name, remove last character which is the parenthese.
        var regularEx = NSRegularExpression().matches(for: patternRule, in: imageDescription)
        //If image name is found, remove first and last characters which are the parentheses.
        if regularEx != ""
        {
            regularEx = String(regularEx.dropFirst())
            regularEx = String(regularEx.dropLast())
            regularEx = filterImageName(imageName: regularEx)
        }
        return regularEx
    }
    
    /**
     * This method take in a string value of image name and remove its file extension then returns plain image name is form of String value.
     */
    private func filterImageName(imageName: String) -> String
    {
        //This returns the String.Index starting from the first character in the name.
        let fromIndex = imageName.startIndex
        //Get the index position of . character to also exclude the file extension, subtract the position of the dot from the total number of chracters in the name to return the remianing number of file extension value.
        let imageExtensionIndex = imageName.count - (imageName.firstIndex(of: ".")?.utf16Offset(in: imageName))!
        //Create an String.Index as target index by saying take off from the name that last number of characters has been already calculated in imageExtensionIndex.
        let toIndex = imageName.index(imageName.endIndex, offsetBy: -imageExtensionIndex)
        //Define the range object based on our from and to String.Index objects.
        let range = fromIndex..<toIndex
        //Subtring the image name based on the given range of indexes and return it as String value.
        return String(imageName[range])
    }
    
    private func retrunTargetRow(collidedBloodTypeName: String) -> Int
    {
        var row = 0

        for bloodType in self.gameScene.optionBloodTypes!
        {
            if collidedBloodTypeName == bloodType.getBloodTypeImageName
            {
                row = bloodType.getLinkedCell
            }
        }
        return row
    }
}

extension NSRegularExpression
{
    func matches(for regex: String, in text: String) -> String
    {
        do{
            //Validate the given regular expression
            let regex = try NSRegularExpression(pattern: regex)
            //Execute the expression against the given text and store the returned list of type NSTextCheckingResult object in results.
            let results = regex.matches(in: text, options: [], range: NSRange(text.startIndex...,in: text))
            //Mapping over NSTextCheckingResult list to get the string value out of each and store them in an array.
            let stringedResults = results.map {
                String(text[Range($0.range, in: text)!])
            }
            //Only first match is needed, validate and ensure the returned string is valid value and not nill.
            return (stringedResults.count > 0) ? stringedResults[0] : ""
        } catch let error{
            print("Invalid regular expression \(error.localizedDescription)")
            return ""
        }
    }
}
