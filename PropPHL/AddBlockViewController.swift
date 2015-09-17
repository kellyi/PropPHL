//
//  AddBlockViewController.swift
//  PropPHL
//
//  Created by Kelly Innes on 9/14/15.
//  Copyright © 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class AddBlockViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    // MARK: - Variables
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var addressMapRKControl: AddressMapSwitch!
    @IBOutlet weak var findBlockButton: FindBlockButton!
    @IBOutlet weak var findLocationButton: UIBarButtonItem!
    @IBOutlet weak var savedBlocksButton: UIBarButtonItem!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phillyLabel: UILabel!
    @IBOutlet weak var addBlockMapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        addressTextField.backgroundColor = .silverColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let segmentValue = defaults.valueForKey("savedSegment") {
            addressMapRKControl.setSelectedIndex(segmentValue as! Int, animated: false)
        }
        toggleAddressAndMap(addressMapRKControl.selectedIndex)
        centerMap()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissKeyboard()
    }
    
    // MARK: - IBActions

    @IBAction func savedBlocksButtonPressed(sender: UIBarButtonItem) {
        //print(addressMapSegmentedControl.selectedSegmentIndex)
        let blockTableVC = self.storyboard?.instantiateViewControllerWithIdentifier("propPHLNavVC") as! UINavigationController!
        self.presentViewController(blockTableVC, animated: true, completion: nil)
    }
    
    @IBAction func findByLocationButtonPressed(sender: UIBarButtonItem) {
        print("location button pressed")
        sender.enabled = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        sender.enabled = true
    }
    
    @IBAction func findBlockButtonPressed(sender: UIButton) {
        addressMapRKControl.selectedIndex == 1 ?
            findBlockButtonTypedAddress() :
            findBlockButtonSentFromPin()
    }
    
    func dummy() -> Void {
        print("dummy")
    }
    
    func findBlockButtonTypedAddress() {
        findBlockButton.enabled = false
        dismissKeyboard()
        let message = addressTextField.text!
        if addressTextField.text == "" {
            findBlockButton.enabled = true
            let title = "Please enter an address!"
            let actions = ["Close"]
            findBlockButton.enabled = true
            showAlert(message, title: title, actions: actions)
        } else {
            let title = "Is this the right block?"
            let actions = ["Yes", "No"]
            findBlockButton.enabled = true
            showAlert(message, title: title, actions: actions)
        }
    }
    
    func findBlockButtonSentFromPin() {
        findBlockButton.enabled = false
        if let loc = placemark {
            let message = "\(loc.addressDictionary) && \(loc.areasOfInterest)"
            let title = "voici"
            let actions = ["close"]
            findBlockButton.enabled = true
            showAlert(message, title: title, actions: actions)
        } else {
            findBlockButton.enabled = true
            return
        }
    }
    
    @IBAction func addressMapRKControlValueChanged(sender: AddressMapSwitch) {
        toggleAddressAndMap(sender.selectedIndex)
        print(sender.selectedIndex)
    }
    
    func toggleAddressAndMap(segmentIndex: Int) {
        if (segmentIndex == 1) {
            addBlockMapView.hidden = true
            phillyLabel.hidden = false
            addressTextField.hidden = false
            findLocationButton.enabled = false
        } else {
            addBlockMapView.hidden = false
            phillyLabel.hidden = true
            addressTextField.hidden = true
            findLocationButton.enabled = true
        }
        defaults.setValue(segmentIndex, forKey: "savedSegment")
    }
    
    // MARK: - Helper Methods
    
    func centerMap() {
        let latitude = 39.9500 as Double
        let longitude = -75.1667 as Double
        let meters = 10_000 as Double
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMakeWithDistance(center, meters, meters)
        let adjustedRegion = addBlockMapView.regionThatFits(region)
        addBlockMapView.setRegion(adjustedRegion, animated: true)
        reverseGeocode(CLLocation(latitude: center.latitude, longitude: center.longitude))
    }
    
    func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) -> Void in
            if error != nil {
                return
            } else if placemarks?.count > 0 {
                let existingAnnotations = self.addBlockMapView.annotations
                self.addBlockMapView.removeAnnotations(existingAnnotations)
                self.placemark = placemarks!.first as CLPlacemark!
                let annotation = MKPointAnnotation()
                let annotationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                annotation.coordinate = annotationLocation
                self.addBlockMapView.addAnnotation(annotation)
            }
        })
    }
    
    // MARK: - MapViewDelegate Methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        pinView!.canShowCallout = false
        return pinView
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last as CLLocation!
        let viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2, 2)
        let adjustedRegion = addBlockMapView.regionThatFits(viewRegion)
        addBlockMapView.setRegion(adjustedRegion, animated: true)
        locationManager.stopUpdatingLocation()
        reverseGeocode(newLocation)
        
    }
    
    // MARK: - Keyboard and TextField Methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // move view up by specified value on receiving notification
    func keyboardWillShow(notification: NSNotification) {
        //findBlockButton.enabled = false
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // move view down by specified value on receiving notification
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        //findBlockButton.enabled = true
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return (keyboardSize.CGRectValue().height - 44.0)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        dismissKeyboard()
        return false
    }
    
    func dismissKeyboard() {
        addressTextField.resignFirstResponder()
    }
    
    // MARK: - Show Alerts

    func showAlert(message: String, title: String, actions: [String]) {
        let alert = DOAlertController(title: title, message: message, preferredStyle: .Alert)
        for actionTitle in actions {
            if actionTitle == "Yes" {
                let action = DOAlertAction(title: actionTitle, style: .Default) { UIAlertAction in self.yesAction() }
                alert.addAction(action)
            } else if actionTitle == "No" {
                let action = DOAlertAction(title: actionTitle, style: .Default) { UIAlertAction in self.noAction() }
                alert.addAction(action)
            } else {
                let action = DOAlertAction(title: actionTitle, style: .Default, handler: nil)
                alert.addAction(action)
            }
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func yesAction() {
        PHLOPAClient.sharedInstance().getPropertyJSONByBlockUsingCompletionHandler(addressTextField.text!, skip: 0) { (success, errorString) in
            
        }
    }
    
    func noAction() {
        print("No")
    }
    
}
