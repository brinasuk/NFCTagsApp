

import UIKit
import MapKit

class SwiftyMapController: UIViewController {
    

//    @IBAction func backButtonPressed(_ sender: Any) {
//    }
    
    @IBOutlet weak var mapView: MKMapView!
    
//    var backButt = UIButton()
//    var latitude: String = ""
//    var longitude: String = ""
//    var latitudeD: Double? = 123
//    var longitudeD: Double? = 456
    
    //var allTagObjects:[TagModel]
    //var allTagObjects = TagModel()
    //var dataParse:NSMutableArray = []// = NSMutableArray()
    var tag = TagModel()
    
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Map View"
    mapView.delegate = self
    setupDarkMode()
    setupNavigationBar()


    
//    for item in tagObjects {
//        print (item.tagTitle)
//    }
    
    //print (dataParse.count)
    
    // Receive data ---> with NSUserdefaults
    //let prefs:UserDefaults = UserDefaults.standard
    
    
//    if let latitudeD = prefs.string(forKey: "SWIFTYLATITUDE"){
//        print("The following Lat was passed: " + latitude)
//        //let latitudeD = (latitude as NSString).doubleValue
//        //let path = Bundle.main.path(forResource: dick, ofType: "json")
//        //members = Member.loadMembersFromFile(path!)
//
//    }else{
//        //Nothing stored in NSUserDefaults Key
//        print("Nothing stored in NSUserDefaults Latitude Key")
//        //prefs.setValue("ALEX", forKey: "SWIFTY")
//    }
    
//    if let latitudeD = prefs.double(forKey: "SWIFTYLATITUDE") {
//        print("The following Long was passed: " + longitude)
//        //let longitudeD = (longitude as NSString).doubleValue
//        //let path = Bundle.main.path(forResource: dick, ofType: "json")
//        //members = Member.loadMembersFromFile(path!)
//
//    }else{
//        //Nothing stored in NSUserDefaults Key
//        print("Nothing stored in NSUserDefaults Longitude Key")
//        //prefs.setValue("ALEX", forKey: "SWIFTY")
//    }
    
//    let tagTitle = prefs.string(forKey: "SWIFTYTITLE")
//    print("tagTitle value = \(String(describing: tagTitle))")
//    let tagAddress = prefs.string(forKey: "SWIFTYADDRESS")
//    print("tagAddress value = \(String(describing: tagAddress))")
//    let latitudeD = prefs.double(forKey: "SWIFTYLATITUDE")
//    print("latitudeD value = \(latitudeD)")
//    let longitudeD = prefs.double(forKey: "SWIFTYLONGITUDE")
//    print("longitudeD value = \(longitudeD)")
    
    let latitude = tag.latitude
    let latitudeD = (latitude as NSString).doubleValue
    let longitude = tag.longitude
    let longitudeD = (longitude as NSString).doubleValue
    //print(latitudeD, longitudeD)
    
//    latitude = "39.60181538"
//    longitude = "-104.86915379"
    
    //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    //latitudeD = (latitude as NSString).doubleValue
    //longitudeD = (longitude as NSString).doubleValue
    let initialLocation = CLLocation(latitude: latitudeD, longitude: longitudeD)

    centerMapOnLocation(location: initialLocation)
    
    let artwork = Artwork(title: tag.tagTitle,
                          locationName: tag.tagCompany,
                          discipline: tag.rating,
                          coordinate: CLLocationCoordinate2D(latitude: latitudeD, longitude: longitudeD))
    mapView.addAnnotation(artwork)
    
  }
    
           func  setupDarkMode() {
               overrideUserInterfaceStyle = .dark //TODO: TAKE THIS OUT OF FINAL VERSION !!!
               
        
               //SET UI CONFIG COLORS
    //           cellBackGroundImageName = "list-item-background"
    //
    //           let backgroundImageName = "art_launch_image"
    //           let backgroundImage = UIImage(named: backgroundImageName)
    //           let imageView = UIImageView(image: backgroundImage)
    //           imageView.contentMode = .scaleAspectFill
    //           imageView.alpha = 0.8
    //           self.tableView.backgroundView = imageView
               
               
               //tabTextColor = .label
               //tabTextColor = .systemRed
               //tabTextColor = .systemFill

    //           navbarTextColor = .label
    //           textColor = .label
    //
    //           navbarBackColor = .secondarySystemBackground // paleRoseColor
    //           //navbarBackColor = .systemGroupedBackground//alex
    //           //navbarBackColor = .systemBlue
    //
    //
    //           //toolBar.barTintColor = navbarBackColor
    //           //view.backgroundColor = navbarBackColor
    //
    //           statusView.backgroundColor = .systemGray4
    //
    //           let labelColor1:UIColor = .systemGray6
    //           let labelColor2:UIColor = textColor!
    //           let labelBorder:UIColor = .systemTeal
    //           //tryThisColor = .systemRed
    //           statusLabel.backgroundColor = labelColor1
    //           statusLabel.textColor = labelColor2
    //           statusView.backgroundColor = labelBorder
    //
    //           statusLabel.layer.cornerRadius = 5.0
    //           statusLabel.layer.masksToBounds = true
    //           //statusLabel.backgroundColor = .white
    //           //statusLabel.textColor = royalBlue
    //           statusLabel.font.withSize(16.0)
    //
    //           //SET THE SCANBUTTON DEFAULTS
    //           scanButton.backgroundColor = .systemBlue
    //           scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    //           scanButton.layer.cornerRadius = scanButton.frame.height/2
    //           scanButton.layer.masksToBounds = true
    //           scanButton.tintColor = textColor
    //
    //           switch overrideUserInterfaceStyle {
    //            case .dark:
    //                // User Interface is Dark
    //                cellBackGroundImageName = "list-item-background-dark"
    //                ()
    //            case .light:
    //                // User Interface is Light
    //                cellBackGroundImageName = "list-item-background"
    //                ()
    //            case .unspecified:
    //                //your choice
    //                cellBackGroundImageName = "list-item-background"
    //                ()
    //            @unknown default:
    //                cellBackGroundImageName = "list-item-background"
    //                ()
    //                //Switch covers known cases, but 'UIUserInterfaceStyle' may have additional unknown values, possibly added in future versions
    //            }
        
             }

    
    func setupNavigationBar() {
        //Customize the navigation bar
        //The following 2 lines make the Navigation Bar transparant
        //METHOD 0
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.navigationBar.tintColor = .darkText //CRITICAL
                navigationController?.hidesBarsOnSwipe = false
                navigationController?.navigationBar.prefersLargeTitles = false
        
        //METHOD 1
        //                navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
        //                navigationItem.largeTitleDisplayMode = .always
        
        //METHOD2
        //        if let customFont = UIFont(name: "Rubik-Medium", size: 34.0) {
        //            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor .darkText, NSAttributedString.Key.font: customFont ]
        //        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    
    @IBAction func backButtonPressed(_ sender: Any) {
        //navigationController!.popViewController(animated: true)
        //[self.navigationController popViewControllerAnimated:YES];
        //[self, dismiss,:YES completion:nil] as [Any];
        //navigationController?.dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
}

//override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    checkLocationAuthorizationStatus()
//}

// MARK: - CLLocationManager

//let locationManager = CLLocationManager()
//func checkLocationAuthorizationStatus() {
//    if CLLocationManager.authorizationStatus() == .authorizedAlways {
//        mapView.showsUserLocation = true
//    } else {
//        locationManager.requestAlwaysAuthorization()
//    }
//    //    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//    //      mapView.showsUserLocation = true
//    //    } else {
//    //      locationManager.requestWhenInUseAuthorization()
//    //    }
//}

// MARK: - Helper methods

//func centerMapOnLocation(location: CLLocation) {
//    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                              regionRadius, regionRadius)
//    mapView.setRegion(coordinateRegion, animated: true)
//}

//func loadInitialData() {
//    // 1
//    guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
//        else { return }
//    let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
//
//    guard
//        let data = optionalData,
//        // 2
//        let json = try? JSONSerialization.jsonObject(with: data),
//        // 3
//        let dictionary = json as? [String: Any],
//        // 4
//        let works = dictionary["data"] as? [[Any]]
//        else { return }
//    // 5
//    let validWorks = works.flatMap { Artwork(json: $0) }
//    artworks.append(contentsOf: validWorks)
//}



// MARK: - MKMapViewDelegate

extension SwiftyMapController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

