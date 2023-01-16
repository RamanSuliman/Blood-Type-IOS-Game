/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate
{
    //Main Game characters
    let jet = SKSpriteNode(imageNamed: "jet.png")
    let bloodDrop = SKSpriteNode(imageNamed: "bloodDrop.png")
    
    //This hash set is used to add a blood type into a distinct list on collision, it ensures the next time the same blood type has been collided nothing will happen since it is already in the list until the list has emptied once new round began.
    var roundAnsweresHashCollection = Set<String>()
    var questionAlreadyAsked = Set<String>()
    var optionBloodTypes: [BloodType]?
    
    //UI elements
    var fireButton: SKSpriteNode?
    var bloodTypeOptionQuestion_txt: SKLabelNode?
    
    var optionImages = [SKSpriteNode]()
    //Call back function used to broadcast collision.
    var broadcastCollision: (()->())?
    
    //This represents the type of input that can be either accelerometer or touch-drag to controll the jet rotation.
    var typeOfInput = "Accelerometer"
    var lastCollidedBloodType: String?
    
    //Collision categories
    let bloodTypeCategory: UInt32 = 0x1 << 0
    let dropBulletCategory: UInt32 = 0x1 << 1
    let hitSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    let fireSound = SKAction.playSoundFileNamed("fire.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.clear
        setGameElements()
        setupTheBloodTypeImages()
        placeBloodTypeImagesOnScreen()
        setNewBloodTypeOptionOnScreen()
    }
    
    /**
     * This method accesses model data and creates a list of UI images corresponding to the retrived blood type objects name property.
     */
    private func setupTheBloodTypeImages()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //Get the active model from the delegate instance.
        optionBloodTypes = appDelegate.dataModel.getBloodTypes()
        //Loop through the list of type BloodType.
        for imageName in optionBloodTypes!
        {
            //Create an image of each type.
            let bloodTypeOptionImage = SKSpriteNode(imageNamed: imageName.getBloodTypeImageName)
            //Assign the name proprty of the image created.
            bloodTypeOptionImage.name = imageName.getBloodTypeImageName
            //Append the image to the list.
            optionImages.append(bloodTypeOptionImage)
        }
    }
    
    /**
     * On call to this method a new blood type option is becoming active for the new round.
     */
    func setNewBloodTypeOptionOnScreen()
    {
        var loopExit = false
        while (!loopExit)
        {
            //Get a random integer in range of 0 and the number of avaliable types.
            let randomOption = Int.random(in: 0..<optionBloodTypes!.count)
            //Retrive the blood type name from the list using the random value ass index position.
            let imageName = optionBloodTypes![randomOption].getBloodTypeImageName
            //If the type has not been presented on the screen yet then assign it and end the loop.
            if (!questionAlreadyAsked.contains(imageName))
            {
                bloodTypeOptionQuestion_txt?.text = imageName
                questionAlreadyAsked.insert(imageName)
                loopExit = true
            }
        }
    }
    
    /**
     * On call to this method a boolean value is returned to determine if the player has done all the questions.
     */
    public func areQuestionEnded() -> Bool
    {
        return (optionBloodTypes!.count == questionAlreadyAsked.count) ? true : false
    }
    
    /**
     * This methods sets up the core UI game controllers on the scene.
     */
    private func setGameElements()
    {
        //Set up a jet object on the scene.
        jet.position = CGPoint(x: size.height / 2, y: 50)
        jet.size = CGSize(width: 50, height: 65)
        addChild(jet)
        
        //Set up UI fire button image.
        fireButton = SKSpriteNode(imageNamed: "fire_button_image.png")
        fireButton!.zPosition = 1
        fireButton!.size = CGSize(width: size.height / 8, height: size.width / 4)
        fireButton!.name = "fireButton"
        fireButton!.position = CGPoint(x: size.height - 80, y: 50)
        addChild(fireButton!)
        
        //Set up UI fire button text.
        let fireButton_txt = SKLabelNode(text: "Fire")
        fireButton_txt.fontColor = .white
        fireButton_txt.fontSize = 25
        fireButton_txt.fontName = "AmericanTypeWriter-Normal"
        fireButton_txt.verticalAlignmentMode = .center
        fireButton_txt.horizontalAlignmentMode = .center
        fireButton_txt.name = "fireButton_txt"
        fireButton_txt.zPosition = 2
        fireButton!.addChild(fireButton_txt)
          
        //Set up UI blood type option that is getting fired.
        let bloodTypeUI_option_background = SKSpriteNode(imageNamed: "sequreButton.png")
        bloodTypeUI_option_background.zPosition = 1
        bloodTypeUI_option_background.size = CGSize(width: size.height / 9, height: size.width / 5)
        bloodTypeUI_option_background.position = CGPoint(x: 90, y: 50)
        addChild(bloodTypeUI_option_background)
        
        //Set up the label that holds the blood type option that changes in each round.
        bloodTypeOptionQuestion_txt = SKLabelNode(text: "AB+")
        bloodTypeOptionQuestion_txt!.fontColor = .white
        bloodTypeOptionQuestion_txt!.fontSize = 25
        bloodTypeOptionQuestion_txt!.fontName = "AmericanTypeWriter-Bold"
        bloodTypeOptionQuestion_txt!.verticalAlignmentMode = .center
        bloodTypeOptionQuestion_txt!.horizontalAlignmentMode = .center
        bloodTypeOptionQuestion_txt!.name = "bloodTypeOptionQuestion"
        bloodTypeOptionQuestion_txt!.zPosition = 2
        bloodTypeUI_option_background.addChild(bloodTypeOptionQuestion_txt!)
        
        //Make the scene to be the physics world's contant area.
        physicsWorld.contactDelegate = self  
    }
    
    /**
     * This method is called in begining of the game, it places the blood type images across the x-axis having each type under one table view.
     */
    private func placeBloodTypeImagesOnScreen()
    {
        //Define the x-axis position of each image by dividing the device hight by the number of avaliable images plus one.
        let widthLocationPerImage = (size.height / CGFloat(optionImages.count + 1))
        //Store a copy of the x-postion value that would be altered later.
        var increamentWidthValue = widthLocationPerImage
        //Loop through the images and assign properties including phisycs settings and category.
        for option in optionImages
        {
            //Position the image to the computed x-axis and define y-axis to be placed under its table
            option.position = CGPoint(x: increamentWidthValue, y: size.width / 1.8)
            //Increase the width a-axis value by the original value for the next image.
            increamentWidthValue += widthLocationPerImage
            //Set the image size according to screen size.
            option.size = CGSize(width: size.height / 20, height: size.width / 11)
            //Define the box collider size for the blood type image.
            let colliderSize = CGSize(width: option.frame.size.width / 2.5, height: option.frame.size.height)
            //Creating an instance of physic body with pre-defined collider size.
            option.physicsBody = SKPhysicsBody(rectangleOf: colliderSize)
            //Turn of the gravity.
            option.physicsBody?.affectedByGravity = false
            //Assosicate the image with a category used for collision.
            option.physicsBody?.categoryBitMask = bloodTypeCategory
            //Define the category expected to collide with its memebrs.
            option.physicsBody?.contactTestBitMask = dropBulletCategory
            option.physicsBody?.collisionBitMask = 0
            addChild(option)
        }
    }
    
    /**
     * This method handles one touch event on the screen, mainly used to detect user tap on fire button.
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else {
            return
        }
        //Get the location of the touch
        let touchLocation = touch.location(in: self)
        
        //Fire button tap handler if touch location is identical with the button location.
        if fireButton!.contains(touchLocation)
        {
            //Play fire sound effect
            run(fireSound)
            
            //On fire button tapped, a drop bullet image is created to be fired.
            let dropBullet = SKSpriteNode(imageNamed: "bloodDrop.png")
            //Define the bullet size.
            dropBullet.size = CGSize(width: 20, height: 20)
            //Set up initial location of projectile
            dropBullet.position = CGPoint(x: jet.position.x, y: jet.position.y)
            //Add physic properties to the bullet.
            let colliderSize = CGSize(width: dropBullet.frame.size.width / 2, height: dropBullet.frame.size.height)
            dropBullet.physicsBody = SKPhysicsBody(rectangleOf: colliderSize)
            dropBullet.physicsBody?.categoryBitMask = dropBulletCategory
            dropBullet.physicsBody?.contactTestBitMask = bloodTypeCategory
            dropBullet.physicsBody?.affectedByGravity = false
            dropBullet.physicsBody?.collisionBitMask = 0
            
            //Create bullet fire particle effect
            let bulletFire = SKEmitterNode(fileNamed: "BulletEffect.sks")!
            //Position it slightly under the bullet.
            bulletFire.position = CGPoint(x: dropBullet.position.x, y: dropBullet.position.y * 0.91)
            //The effect rotation must be set according to the cannon z rotation.
            bulletFire.zRotation = jet.zRotation
            
            //Make a casting line for the dropBullet to move across.
            let x = (jet.zRotation != 0) ? Int(-jet.zRotation * 750) : 0
            let dx = CGFloat(x)
            let vector = CGVector(dx: dx, dy: 10.0 * jet.position.y)
            
            //Moving the bullet with a duration live time that once ended the bullet object is removed.
            let bulletMove = SKAction.move(by: vector, duration: 1.2)
            let butlletMoveDone = SKAction.removeFromParent()
            let sequence = SKAction.sequence([bulletMove, butlletMoveDone])
           
            addChild(dropBullet)
            addChild(bulletFire)
            //The same action and animation is applied to both the bullet and its fire effect.
            bulletFire.run(sequence)
            dropBullet.run(sequence)
        }
    }
    
    /**
     * This method is called on event of touch and drag, it is used to rotate the jet to left or right depending on drag x-axis movement.
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with: event)
        if typeOfInput == "tocuh_drag"
        {
            for touch in touches
            {
                //Takes the current touch lcoation.
                let location = touch.location(in: self)
                //Get the previous and initial touch location.
                let previousLocation = touch.previousLocation(in: self)
                //Workout the different between two x-axis coordinates.
                let translation = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
                //If the difference value is positive means drag to the right then the jet should rotate to the right by 0.2 else -0.2
                let increaseRotationBy = (translation.x > 0) ?  0.2 : -0.2
                //Pass the computed value to perform the rotation.
                updateJet_Rotation(increaseX_axisBy: increaseRotationBy)
            }
        }
    }
    
    /**
     * This method takes in a double value to apply rotation on then jet object. It is called by touchMoved or accelerometer at a time.
     */
    public func updateJet_Rotation(increaseX_axisBy: Double)
    {
        //Get the current jet rotaion and round the value to one decimal place.
        let jetRot =  round(jet.zRotation * 10) / 10
        //Apply constraint to prevent the jet to rotate outside the defined range.
        if(jetRot < 1.5 && jetRot > -1.5)
        {
            //If jet reached the edge of allowed range then decrease the rotation.
            if(jetRot == 1.4 || jetRot == -1.4)
            {
                jet.zRotation += CGFloat(increaseX_axisBy)
                return
            }
            //Increase the rotation to the right or left depending on the value of increaseX_axisBy.
            jet.zRotation -= CGFloat(increaseX_axisBy)
        }
    }
    
    /**
     * This method handles collision detections between game objects with physic properties applied on.
     */
    //Physiscs collision detection
    func didBegin(_ contact: SKPhysicsContact)
    {
        //Make sure both bodies have nodes attached to.
        guard contact.bodyA.node != nil else { return }
        guard contact.bodyB.node != nil else { return }
        //Cast the name of blood type object to string.
        let name = String((contact.bodyA.node?.name)!)
        //Check if the blood type hasn't already been collided with in same round.
        if(!roundAnsweresHashCollection.contains(name))
        {
            //Play explosion sound effect
            run(hitSound)
            //Save the name of last collided blood tye.
            lastCollidedBloodType = name
            //Play explosion effect.
            let explosion = SKEmitterNode(fileNamed: "Explosion.sks")!
            //Assing the explosion to the position of the blood type that has been collided with.
            explosion.position = (contact.bodyA.node as! SKSpriteNode).position
            addChild(explosion)
            //Remove the blood drop bullet from the scene once is collided with a blood type.
            contact.bodyB.node?.removeFromParent()
            //Call the call back function to brodacst collision to other system components.
            broadcastCollision!()
            //Append blood type to hash set list to exclude it from next collision until list is emptied.
            roundAnsweresHashCollection.insert(name)
            //Define the live duration in second for the explosion before removing from the scene.
            run(SKAction.wait(forDuration: 0.5))
            {
                explosion.removeFromParent()
            }
        }
    }
}
