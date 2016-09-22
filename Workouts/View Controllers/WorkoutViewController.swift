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

private let addWorkoutIndex = 0
private let addNewIdentifier = "AddWorkoutCell"
private let workoutIdentifier = "WorkoutCell"
private let toWorkoutDetailIdentifier = "toWorkoutDetailViewController"
private let toAddWorkoutIdentifier = "toAddWorkoutViewController"

class WorkoutViewController: UIViewController {
  
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
    
  let dataModel = DataModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.accessibilityIdentifier = "Workouts Table"
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    updateEditButtonVisibility()
    toggleEditMode(false)
    
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == toAddWorkoutIdentifier {
      let destinationViewController = segue.destination as! AddWorkoutViewController
      destinationViewController.dataModel = dataModel
    } else if segue.identifier == toWorkoutDetailIdentifier {
      let indexPath = sender as! IndexPath
      let destinationViewController = segue.destination as! WorkoutDetailViewController
      destinationViewController.workout = dataModel.allWorkouts[(indexPath as NSIndexPath).row - 1]
    }
  }
  
  @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    toggleEditMode(!tableView.isEditing)
  }
  
  fileprivate func toggleEditMode(_ editing: Bool) {
    tableView.setEditing(editing, animated: true)
    editButton.title = editing ? "Done" : "Edit"
  }
  
  fileprivate func updateEditButtonVisibility() {
    editButton.isEnabled = dataModel.containsUserCreatedWorkout
  }
}

extension WorkoutViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.allWorkouts.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    if (indexPath as NSIndexPath).row == addWorkoutIndex {
      cell = tableView.dequeueReusableCell(withIdentifier: addNewIdentifier)!
    } else {
      let workout = dataModel.allWorkouts[(indexPath as NSIndexPath).row - 1]
      cell = tableView.dequeueReusableCell(withIdentifier: workoutIdentifier)!
      (cell as! WorkoutCell).populate(workout)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if (indexPath as NSIndexPath).row == addWorkoutIndex {
      return false
    } else {
      return dataModel.allWorkouts[(indexPath as NSIndexPath).row - 1].canEdit
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      dataModel.removeWorkoutAtIndex((indexPath as NSIndexPath).row - 1)
      
      tableView.deleteRows(at: [indexPath], with: .automatic)
      updateEditButtonVisibility()
    }
  }
  
}

extension WorkoutViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).row == addWorkoutIndex {
      performSegue(withIdentifier: toAddWorkoutIdentifier, sender: nil)
    } else {
      performSegue(withIdentifier: toWorkoutDetailIdentifier, sender: indexPath)
    }
  }
}
