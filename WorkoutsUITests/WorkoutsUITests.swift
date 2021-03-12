//
//  WorkoutsUITests.swift
//  WorkoutsUITests
//
//  Created by Zook Gek on 9/22/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import XCTest

class WorkoutsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testFullBodyWorkout() {
        let app = XCUIApplication()
        
        // 1. Get references to all of the tables in the app.
        let tableQuery = app.descendants(matching: XCUIElement.ElementType.table)
        
        // 2. Find the Workouts table using the "Workouts Table" accessibility identifier you added earlier. After that, you simulate a tap on the cell that contains the static text "Full Body Workout".

        let workoutTable = tableQuery["Workouts Table"]
        let cellQuery = workoutTable.children(matching: XCUIElement.ElementType.cell)
        
        let identifier = "Full Body Workout"
        let workoutQuery = cellQuery.containing(XCUIElement.ElementType.staticText, identifier:identifier)
        
        let workoutCell = workoutQuery.element
        
        workoutCell.tap()
        
        // 3. Get the navigaiton bar
        let navBarQuery = app.descendants(matching: XCUIElement.ElementType.navigationBar)
        
        let navBar = navBarQuery[identifier]
        
        let buttonQuery = navBar.descendants(matching: XCUIElement.ElementType.button)
        let backButton = buttonQuery["Workouts"]
        backButton.tap()
    }
    
    func _testExercisesTab() {
    }
}
