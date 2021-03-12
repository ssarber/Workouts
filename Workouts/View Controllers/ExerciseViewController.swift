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
private let exerciseIdentifier = "ExerciseCell"
private let addExerciseNewIdentifier = "AddWorkoutCell"
private let toDetailSegue = "toExerciseDetailViewController"

class ExerciseViewController: UIViewController {
  
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  
  let dataModel = DataModel()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    updateEditButtonVisibility()
    toggleEditMode(false)
  }

  func createUserExercise() {
    let alert = UIAlertController(title: "Add New Exercise",
      message: "Add a new exercise below",
      preferredStyle: UIAlertController.Style.alert)
    
    let cancelAction = UIAlertAction(title: "Cancel",
      style: .default,
      handler: nil)
    
    let saveAction = UIAlertAction(title: "Save",
      style: .default) { action in
        let nameTextField = alert.textFields![0]
        let durationTextField = alert.textFields![1]
        let instructionsTextField = alert.textFields![2]
        
        let exercise = Exercise()
        exercise.userCreated = true
        exercise.name = nameTextField.text
        exercise.duration = Double(durationTextField.text!)
        exercise.instructions = instructionsTextField.text
        
        //create default
        exercise.photoFileName = "customExercise"
        
        self.dataModel.addExercise(exercise)

        self.updateEditButtonVisibility()
        
        self.tableView.reloadData()
    }
    
    alert.addTextField {
      textField in
      textField.placeholder = "Name"
    }
    
    alert.addTextField {
      textField in
      textField.keyboardType = .numberPad
      textField.placeholder = "e.g. 30"
    }
    
    alert.addTextField {
      textField in
      textField.placeholder = "Instructions (Optional)"
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    self.present(alert,
      animated: true,
      completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == toDetailSegue {
      let indexPath = sender as! IndexPath
      let detailViewController = segue.destination as! ExerciseDetailViewController
      detailViewController.exercise = dataModel.allExercises[(indexPath as NSIndexPath).row - 1]
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
    editButton.isEnabled = dataModel.containsUserCreatedExercise
  }
}

extension ExerciseViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataModel.allExercises.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    
    if (indexPath as NSIndexPath).row == addWorkoutIndex {
      cell = tableView.dequeueReusableCell(withIdentifier: addExerciseNewIdentifier)!
      cell.textLabel?.text = "Add New Exercise"
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: exerciseIdentifier)!

      let exercise = dataModel.allExercises[(indexPath as NSIndexPath).row - 1]
      (cell as! ExerciseCell).populate(exercise)
    }
    
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if (indexPath as NSIndexPath).row == addWorkoutIndex {
      return false
    } else {
      return dataModel.allExercises[(indexPath as NSIndexPath).row - 1].canRemove
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      dataModel.removeExerciseAtIndex((indexPath as NSIndexPath).row - 1)
      
      tableView.deleteRows(at: [indexPath], with: .automatic)
      updateEditButtonVisibility()
    }
  }
}

extension ExerciseViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).row == addWorkoutIndex {
      createUserExercise()
    } else {
      performSegue(withIdentifier: toDetailSegue, sender: indexPath)
    }
  }
}
