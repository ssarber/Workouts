//
//  DataModelTests.swift
//  Workouts
//
//  Created by Zook Gek on 9/22/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import XCTest
@testable import Workouts

class DataModelTests: XCTestCase {
    var dataModel: DataModel!
    
    override func setUp() {
        super.setUp()
        
        dataModel = DataModel()
    }
    
    func testSampleDataAdded() {
        XCTAssert(dataModel.allWorkouts.count > 0)
        XCTAssert(dataModel.allExercises.count > 0)
    }
    
    func testAllExcercisesEqualsExcersicesArray() {
        XCTAssertEqual(dataModel.exercises, dataModel.allExercises)
    }

    func testContainsUSerCreatedWorkout() {
        XCTAssertFalse(dataModel.containsUserCreatedWorkout)
        
        let workout1 = Workout()
        dataModel.addWorkout(workout1)
        
        XCTAssertFalse(dataModel.containsUserCreatedWorkout)
        
        let workout2 = Workout()
        workout2.userCreated = true
        dataModel.addWorkout(workout2)
        
        XCTAssert(dataModel.containsUserCreatedWorkout)
        
        dataModel.removeWorkoutAtIndex(dataModel.allWorkouts.count - 1)
        
        XCTAssertFalse(dataModel.containsUserCreatedWorkout)
        
    }
    
    func testContainsUSerCreatedExercise() {
        
        XCTAssertFalse(dataModel.containsUserCreatedExercise)
        
        let exercise1 = Exercise()
        dataModel.addExercise(exercise1)
        XCTAssertFalse(dataModel.containsUserCreatedExercise)
        
        let exercise2 = Exercise()
        exercise2.userCreated = true
        dataModel.addExercise(exercise2)
        
        XCTAssert(dataModel.containsUserCreatedExercise)
        
        dataModel.removeExerciseAtIndex(dataModel.allExercises.count - 1)
        
        XCTAssertFalse(dataModel.containsUserCreatedExercise)
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
