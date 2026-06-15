# WaterBoost 💧

**WaterBoost**  is a news app with a nice looking user interface! The app's architecture is MVVM and also modular

## ✨ Features
  💧 Track daily water intake
  🔒 Restrict selected apps using Screen Time APIs
  🎯 Reward-based unlocking system
  📱 Real-time animated water level visualization
  📊 Persistent hydration progress tracking
  🔄 Data sharing between the main app and extensions via App Groups


## 💡 Technical Highlights
**SwiftUI & CoreMotion Animation**
  Developed an interactive home screen animation using SwiftUI and CoreMotion. The water inside a circular container dynamically responds to device movement, creating a gravity-based water fill effect that tilts in real time according to the device's orientation.
**App Restriction System**
  - Implemented app blocking and unlocking functionality using:
  - FamilyControls
  - ManagedSettings
  - DeviceActivity
  
  Users can select specific applications to restrict. Logging water intake temporarily removes these restrictions, creating a habit-building reward mechanism.
    
**Persistent Storage**
  Used @AppStorage to persist:
  - Daily water consumption
  - User preferences
  - Selected app restriction data
  - Extension Communication
    
Implemented data sharing between the main application and the DeviceActivityMonitorExtension through App Groups, enabling synchronized restriction management and throttling logic across processes.

**Technologies**
- Swift
- SwiftUI
- CoreMotion
- FamilyControls
- ManagedSettings
- DeviceActivity
- App Groups
- AppStorage

**Architecture**
- MVVM Architecture
- SwiftUI State Management
- Extension-based Screen Time Monitoring

## 📸 Screenshots
<p align="center">
  <img width="230" height="500" alt="IMG_2646" src="https://github.com/user-attachments/assets/b15370aa-59ee-4860-a2df-2c27a8a636be" />
  <img width="230" height="500" alt="IMG_2647" src="https://github.com/user-attachments/assets/a2746473-1ecf-4d9e-bf15-6f2882cad34a" />
  <img width="230" height="500" alt="IMG_2648" src="https://github.com/user-attachments/assets/336f7f0f-6613-4769-9d94-8799a6ca2da0" />
  <img width="230" height="500" alt="IMG_2649" src="https://github.com/user-attachments/assets/470f1aa4-643e-466b-91c4-5ddb972ebc59" />
  <img width="230" height="500" alt="IMG_2650" src="https://github.com/user-attachments/assets/e8ff200a-ddbd-48e0-87af-4e0dd2e7578a" />
</p>

## 📄 License
  - This project is licensed under the MIT License.
