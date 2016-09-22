/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

private let infoCellIdentifier = "AddWorkoutInfoCell"
private let exerciseCellIdentifier = "AddWorkoutExerciseCell"

class AddWorkoutViewController: UIViewController {
  
  var nameTextField: UITextField!
  var restIntervalTextField: UITextField!
  var dataModel: DataModel!
  
  @IBOutlet weak var tableView: UITableView!

  @IBAction func saveButtonTapped(_ sender: AnyObject) {
    let workout = Workout()
    workout.userCreated = true
    workout.name = nameTextField.text
    if let restIntervalText = restIntervalTextField.text,
      let restInterval = Double(restIntervalText) {
        workout.restInterval = restInterval
    }
    
    if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
      for indexPath in selectedIndexPaths {
        workout.addExercise(dataModel.allExercises[(indexPath as NSIndexPath).row])
      }
    }
    
    dataModel.addWorkout(workout)

    navigationController?.popViewController(animated: true)
  }
  
  // MARK - Helper methods
  
  func workoutInfoCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier) as! AddWorkoutInfoCell
    cell.selectionStyle = .none
    
    if (indexPath as NSIndexPath).row == 0 {
      cell.infoLabel.text = "Name"
      cell.infoTextField.placeholder = "Workout name"
      nameTextField = cell.infoTextField
    } else {
      cell.infoLabel.text = "Rest Interval"
      cell.infoTextField.placeholder = "e.g. 30"
      cell.infoTextField.keyboardType = .numberPad
      restIntervalTextField = cell.infoTextField
    }
    
    return cell
  }
  
}

extension AddWorkoutViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return (section == 0) ? "Workout Info" : "Add Exercises"
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (section == 0) ? 2 : dataModel.allExercises.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    if (indexPath as NSIndexPath).section == 0 {
      cell = workoutInfoCellForIndexPath(indexPath)
    } else {
      let exercise =  dataModel.allExercises[(indexPath as NSIndexPath).row]
      cell = tableView.dequeueReusableCell(withIdentifier: exerciseCellIdentifier)!

      (cell as! AddWorkoutExerciseCell).populate(exercise)
    }
    
    return cell
  }
  
}
