// SUPERSET FIXES - BELANGRIJKE WIJZIGINGEN VOOR JE APP
// ------------------------------------------------------

// 1. ORIENTATIE VERGRENDELING OP iOS 18.3
// ------------------------------------------------------
// Plaats dit bovenaan je SuperSetApp.swift bestand, direct na de import-statements:

import SwiftUI
import UIKit

// Klasse voor het geforceerd in portrait mode zetten van de app
class OrientationLock: ObservableObject {
    static let shared = OrientationLock()
    
    // Houdt bij of oriëntatie lock actief is
    @Published private(set) var isLocked = false
    
    // Forceer portret oriëntatie op iOS 18.3
    func lockOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        
        // Zorg ervoor dat we een view controller hebben die oriëntatie beheert
        setupOrientationLock()
        isLocked = true
    }
    
    // Window voor oriëntatie vergrendeling
    private var orientationLockWindow: UIWindow?
    
    // Child view controller die portrait mode afdwingt
    private class PortraitViewController: UIViewController {
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
        
        override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
            return .portrait
        }
        
        override var shouldAutorotate: Bool {
            return false
        }
    }
    
    private func setupOrientationLock() {
        if orientationLockWindow == nil {
            // Maak een nieuwe offscreen window met een portrait-only controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                let viewController = PortraitViewController()
                window.rootViewController = viewController
                window.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
                window.isHidden = false
                self.orientationLockWindow = window
            }
        }
    }
}

// 2. ORIENTATIELOCK ACTIVEREN IN DE APP
// ------------------------------------------------------
// Zoek de SuperSetApp struct en verander deze als volgt:

struct SuperSetApp: App {
    // Voeg deze regel toe:
    @StateObject private var orientationLock = OrientationLock.shared
    
    var body: some View {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Voeg deze regel toe om oriëntatie te vergrendelen bij opstarten
                    orientationLock.lockOrientation()
                }
        }
    }
}

// 3. NAVIGATIEKNOPPEN BOVENAAN PLAATSEN IN OEFENMODUS
// ------------------------------------------------------
// Zoek de code voor de oefenmodus/practice mode en voeg deze logica toe
// voor het plaatsen van de navigatieknoppen bovenaan het scherm:

// VOORBEELD (pas aan naar jouw specifieke UI code):
VStack {
    // Navigatieknoppen bovenaan in oefenmodus
    if inOefenModus {
        HStack {
            Button("Terug") {
                // terug actie
            }
            Spacer()
            Button("Home") {
                // home actie
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
    
    // Rest van de UI
    // ... jouw game UI ...
    
    // Navigatieknoppen onderaan ALLEEN als we NIET in oefenmodus zijn
    if !inOefenModus {
        HStack {
            Button("Terug") {
                // terug actie
            }
            Spacer()
            Button("Home") {
                // home actie
            }
        }
        .padding()
    }
}

// 4. BELANGRIJK VOOR INFO.PLIST
// ------------------------------------------------------
// Zorg dat je in je Info.plist de volgende sleutels hebt:
// UISupportedInterfaceOrientations
// - UIInterfaceOrientationPortrait
// - UIInterfaceOrientationPortraitUpsideDown 
// - UIInterfaceOrientationLandscapeLeft
// - UIInterfaceOrientationLandscapeRight
//
// De app zal dankzij de OrientationLock code alsnog in portrait-only blijven,
// maar deze instellingen zijn nodig voor App Store goedkeuring.

// 5. BUILD EN TEST STAPPEN
// ------------------------------------------------------
// 1. Maak een volledige clean build (Cmd+Shift+K gevolgd door Cmd+B)
// 2. Start de app op de iPad
// 3. Controleer dat de orientatie vergrendeld is in portrait mode
// 4. Ga naar de oefenmodus en controleer dat de navigatieknoppen bovenaan staan
// 5. Controleer andere modes om te zien dat de knoppen op de originele positie staan 