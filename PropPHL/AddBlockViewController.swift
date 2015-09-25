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
    @IBOutlet weak var appInfoButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var deletePinButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var alertDisplayed = false
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        addressTextField.backgroundColor = .silverColor()
        appInfoButton.tintColor = .oceanColor()
        savedBlocksButton.tintColor = .oceanColor()
        self.title = "PropPHL"
        locationManager.delegate = self
        centerMap()
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let segmentValue = defaults.valueForKey("savedSegment") {
            addressMapRKControl.setSelectedIndex(segmentValue as! Int, animated: false)
        }
        makeButtonsActiveAndRemoveSpinner()
        toggleAddressAndMap(addressMapRKControl.selectedIndex)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    func disableButtonsAndShowSpinner() {
        // using self. here in case this is called from within a closure
        self.spinner.hidden = false
        self.spinner.startAnimating()
        self.findBlockButton.enabled = false
        self.deletePinButton.enabled = false
        self.findLocationButton.enabled = false
        self.savedBlocksButton.enabled = false
        self.appInfoButton.enabled = false
        self.addressMapRKControl.enabled = false
    }
    
    func makeButtonsActiveAndRemoveSpinner() {
        // using self. here in case this is called from within a closure
        self.spinner.hidden = true
        self.spinner.stopAnimating()
        self.findBlockButton.enabled = true
        self.deletePinButton.enabled = true
        self.findLocationButton.enabled = true
        self.savedBlocksButton.enabled = true
        self.appInfoButton.enabled = true
        self.addressMapRKControl.enabled = true
    }
    
    // MARK: - IBActions

    @IBAction func appInfoButtonPressed(sender: UIBarButtonItem) {
        let appInfoVC = self.storyboard?.instantiateViewControllerWithIdentifier("infoVC") as! InfoViewController!
        self.presentViewController(appInfoVC, animated: true, completion: nil)
    }
    
    @IBAction func deletePinButtonPressed(sender: UIBarButtonItem) {
        removeAllAnnotations()
    }
    
    @IBAction func findByLocationButtonPressed(sender: UIBarButtonItem) {
        findLocationButton.enabled = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func findBlockButtonPressed(sender: UIButton) {
        disableButtonsAndShowSpinner()
        addressMapRKControl.selectedIndex == 1 ?
            findBlockButtonTypedAddress() :
            findBlockButtonSentFromPin()
    }
    
    func findBlockButtonTypedAddress() {
        dismissKeyboard()
        getBlockFromAddress(addressTextField.text!)
    }
    
    func findBlockButtonSentFromPin() {
        if let loc = self.addBlockMapView.annotations.first {
            if loc.subtitle! != "Philadelphia" {
                showAlert("I've only got data for Philadelphia.")
                
            } else {
                getBlockFromAddress(loc.title! as String!)
            }
        } else {
            showAlert("Couldn't find a pin!")
        }
    }
    
    func getBlockFromAddress(address: String) {
        var userGivenAddress = address
        if userGivenAddress.characters.first == " " {
            userGivenAddress = String(userGivenAddress.characters.dropFirst())
        }
        if let blockAddress = streetBlockFromAddressString(userGivenAddress) {
            PHLOPAClient.sharedInstance().getBlockJSONUsingCompletionHandler(blockAddress) { (success, errorString) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        CoreDataStackManager.sharedInstance().saveContext()
                        self.showAlert("Saved \(blockAddress.capitalizeStreetName())!")
                    } else {
                        self.showAlert("\(errorString!)")
                    }
                })
            }
        } else {
            showAlert("Couldn't validate your address!")
        }
    }
    
    @IBAction func addressMapRKControlValueChanged(sender: AddressMapSwitch) {
        toggleAddressAndMap(sender.selectedIndex)
    }
    
    func toggleAddressAndMap(segmentIndex: Int) {
        let segmentBool = segmentIndex == 0 ? true : false
        addBlockMapView.hidden = !segmentBool
        phillyLabel.hidden = segmentBool
        addressTextField.hidden = segmentBool
        findLocationButton.enabled = segmentBool
        deletePinButton.enabled = segmentBool
        defaults.setValue(segmentIndex, forKey: "savedSegment")
    }
    
    // MARK: - MapViewDelegate and CLLocationManagerDelegate Methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        pinView!.canShowCallout = true
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        removeAllAnnotations()
    }
    
    func removeAllAnnotations() {
        let existingAnnotations = self.addBlockMapView.annotations
        self.addBlockMapView.removeAnnotations(existingAnnotations)
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        showAlert("I couldn't load the map.", actions: ["OK"], message: "Are you connected to a network?")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last as CLLocation!
        let viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1000, 1000)
        let adjustedRegion = addBlockMapView.regionThatFits(viewRegion)
        addBlockMapView.setRegion(adjustedRegion, animated: true)
        locationManager.stopUpdatingLocation()
        reverseGeocode(newLocation)
    }
    
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
                self.removeAllAnnotations()
                let place = placemarks!.first as CLPlacemark!
                let annotation = MKPointAnnotation()
                let annotationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                annotation.coordinate = annotationLocation
                annotation.title = "\(place.subThoroughfare!) \(place.thoroughfare!)"
                annotation.subtitle = "\(place.locality!)"
                self.addBlockMapView.addAnnotation(annotation)
                self.findLocationButton.enabled = true
            }
        })
    }
    
    // MARK: - Show Alerts

    func showAlert(title: String, actions: [String] = ["OK"], message: String = "") {
        if alertDisplayed == true {
            makeButtonsActiveAndRemoveSpinner()
            return
        } else {
            alertDisplayed = true
        }
        let alert = DOAlertController(title: title, message: message, preferredStyle: .Alert)
        for actionTitle in actions {
            let action = DOAlertAction(title: actionTitle, style: .Default) {(Void) in
                self.alertDisplayed = false
            }
            alert.addAction(action)
    
        }
        makeButtonsActiveAndRemoveSpinner()
        presentViewController(alert, animated: true, completion: nil)
    }

}

extension AddBlockViewController {
    
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
        appInfoButton.enabled = false
        appInfoButton.tintColor = .clearColor()
        savedBlocksButton.enabled = false
        savedBlocksButton.tintColor = .clearColor()
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // move view down by specified value on receiving notification
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        appInfoButton.enabled = true
        appInfoButton.tintColor = .oceanColor()
        savedBlocksButton.enabled = true
        savedBlocksButton.tintColor = .oceanColor()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return (keyboardSize.CGRectValue().height - 44.0)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        addressTextField.resignFirstResponder()
    }
    
}
