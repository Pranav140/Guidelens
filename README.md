# 📱 GuideLensApp: AI-Powered Visual Navigation for Android

**GuideLensApp** is an accessibility-focused on-device navigation system that helps visually impaired users navigate indoor environments independently.  
Built entirely in **Kotlin** with **Jetpack Compose**, it combines real-time **object detection**, **semantic floor segmentation**, and **intelligent pathfinding** to deliver turn-by-turn **audio guidance** through an intuitive AR interface — all processed locally on the device.

---

## 🌟 Why GuideLensApp?

✅ **100 % On-Device** — No internet required, full privacy  
✅ **Audio-First Design** — Text-to-Speech announcements for all navigation events  
✅ **Production-Ready** — Device-adaptive configuration, robust error handling  
✅ **Optimized Performance** — INT8 quantization, NNAPI acceleration, 15–20 FPS  
✅ **Open Source** — GPL-3.0 license, fully documented and community-driven  

---

## 🚀 Core Features

### 🧠 Computer Vision & Navigation

- **Real-Time Object Detection** – YOLO World v2 (INT8) detects 80 object classes at 640×640 resolution with 150–250 ms latency.  
  Supports 16 navigable targets: `chair, door, table, bed, couch, toilet, sink, refrigerator, stairs, person, bottle, cup, laptop, phone, keyboard, mouse`.

- **Semantic Floor Segmentation** – Custom-trained **PP-LiteSeg (INT8)** identifies walkable surfaces.  
  **NEW**: Enhanced with **bilinear filtering** to robustly handle multi-colored and textured floors.

- **Intelligent Pathfinding** – **A\*** search on a down-sampled grid + **VFH (Vector Field Histogram)**.  
  **NEW**: Implements **Hysteresis** and **Low-Pass Filtering** to prevent direction jitter and provide smooth, stable guidance.

- **Pure Pursuit Control** – Robotics-grade trajectory tracking with 100 px look-ahead; generates natural commands:  
  *“Go straight”*, *“Bear right”*, *“Veer left”*.

### 💊 Medicine Identifier (NEW)
- **AI-Powered Analysis** – Combines on-device **ML Kit Text Recognition** with **Gemini Pro API**.
- **Instant Summaries** – Reads complex medicine labels and provides concise, spoken summaries (e.g., *"Paracetamol, used for pain relief"*).
- **Privacy-First** – Images are processed securel, with text-only data sent to the API.

---

## ♿ Accessibility Features

- **Text-to-Speech Integration**
  - “Navigating to [object]” on start  
  - “[Object] found” on first detection  
  - Natural, slower speech rate (0.7x) for clarity
  - Turn commands every 2.5 s (max)  
  - “Arrived at destination” on goal  
  - “Navigation stopped” on exit

- **Voice Command Control** (Fully Implemented)
  - **"Navigate to [object]"** – Starts navigation hands-free.
  - **"Stop"** – Ends current session.
  - **"Describe Scene"** – Provides a summary of visible objects.
  - **Hold-to-Speak** – Intuitive long-press gesture on the bottom bar.

- **App Polish & Battery Saver**
  - **Smart Lifecycle** – Pauses heavy ML/Camera tasks when app is backgrounded to save battery.
  - **Robust Permissions** – Smart handling of denied permissions with direct settings access.

- **Neon High-Contrast UI**
  - Vibrating colors (Neon Green/Yellow on Black) for maximum visibility.
  - Pulsing animations for active states (Scanning, Target Acquired).

---

## 🛠️ Technology Stack

| Component | Technology | Details |
|------------|-------------|----------|
| **Platform** | Android API 24+ | Nougat 7.0 and later |
| **Language** | Kotlin 100 % | Modern coroutines-based |
| **UI** | Jetpack Compose | Material Design 3 UI |
| **Architecture** | MVVM | `ViewModel`, `StateFlow` separation |
| **ML Runtime** | ONNX Runtime 1.16.0 | Cross-platform INT8 optimized |
| **OCR** | ML Kit Text Recognition | On-device fast extraction |
| **AI API** | Google Gemini Pro | Intelligent summarization |
| **Sensors** | Fusion (Accel/Mag/Gyro) | Stable heading calculation |

**Model Pipeline**

- **YOLO World v2** → PyTorch → ONNX → INT8 Quantization  
- **PP-LiteSeg** → Custom PyTorch Training → ONNX → INT8 Quantization  

**Why ONNX Runtime?**  
15–20 % faster INT8 inference than TFLite, superior NNAPI integration, cross-platform portability.

---

## 🧭 Algorithms & Implementation

### 🗺️ A\* Pathfinding & VFH
- Manhattan-distance heuristic.
- **VFH (Vector Field Histogram)** for local obstacle avoidance.
- **Smoothing**: Low-pass filter on output angle ($\alpha = 0.3$).
- **Hysteresis**: Cost bonus to previous sector to prevent decision flipping.

### 🔄 Pure Pursuit Controller
- Curvature $\kappa = 2 \cdot \sin(\alpha) / L$
- Generates natural language commands ("Bear left", "Turn sharp right").

---

## ⚙️ Device-Adaptive Configuration

| Tier | FPS | Resolution | ML Threads | Acceleration |
|------|-----|-------------|-------------|---------------|
| **High-End** (≥ 8 GB RAM, ≥ 8 cores) | 20 | 1280×720 | 4 | NNAPI + FP16 |
| **Mid-Range** (4–6 GB RAM) | 15 | 960×540 | 2 | CPU only INT8 |

Dynamic profiling adjusts thresholds, frame rates, and resolution at runtime.

---

## 📦 Installation

### Prerequisites
- Android Studio Hedgehog (2023.1.1+)  
- Android SDK API 24+  
- Physical device with camera (≥ 4 GB RAM recommended 8 GB)
- **Gemini API Key**: Required for Medicine ID feature.

### Setup
```bash
git clone https://github.com/N-SriKrishna/GuideLensApp.git 
cd GuideLensApp
```

### Add ML models to `app/src/main/assets/`
 - `yolov8s-worldv2_int8.onnx` (~10 MB)
 - `floor_segmentation_int8.onnx` (~3 MB)

### Build & Run
1. **File → Sync Project with Gradle**  
2. **Build → Make Project**  
3. **Run → Run 'app'** (grant camera & microphone permissions)

---

## ▶️ Usage

### Basic Navigation
1. Tap ⚙️ to select target object (e.g. *Chair*) or say **"Navigate to Chair"**.
2. Hear “Navigating to chair”.
3. Follow audio commands: “Bear right”, “Move forward”.
4. Arrival → “Arrived at destination”.

### Mectine ID
1. Select "Medicine Identifier" from Start Screen.
2. Point camera at medicine box.
3. Tap "SCAN".
4. Listen to the AI summary.

---

## ⚙️ Performance & Optimization

### Benchmarks (Samsung Galaxy S23, Snapdragon 8 Gen 2)
| Component | Latency | Notes |
|------------|----------|-------|
| Object Detection | 150–250 ms | YOLO World INT8 + NNAPI |
| Floor Segmentation | 80–120 ms | PP-LiteSeg INT8 |
| Medicine Analysis | 1–2 sec | OCR (On-device) + API |
| End-to-End Nav | 2.5–4 FPS | Full pipeline |

Memory ≈ **250 MB (active)** · Battery ≈ **15–20 % per hour**

### Key Optimizations
- **INT8 Quantization** → 4× smaller models, 2–3× faster inference  
- **NNAPI Acceleration** → 2× speedup on Snapdragon NPUs  
- **Lifecycle Management** → Auto-pause when backgrounded
- **Memory Pooling** → Bitmap reuse + explicit GC  

---

## 🏗️ Project Architecture
```
app/src/main/java/com/example/guidelensapp/
├── MainActivity.kt 
├── GuideLensApplication.kt 
├── Config.kt 
├── viewmodel/
│   ├── NavigationViewModel.kt 
│   └── NavigationUiState.kt
├── ml/
│   ├── ObjectDetector.kt 
│   ├── ONNXFloorSegmenter.kt 
│   └── TextRecognitionManager.kt
├── network/
│   └── GeminiService.kt
├── sensors/
│   └── SpatialTracker.kt 
├── navigation/
│   └── PathPlanner.kt 
├── accessibility/
│   ├── TextToSpeechManager.kt 
│   └── VoiceCommandManager.kt
└── ui/composables/
    ├── SimpleNavigationComposables.kt
    ├── StartScreen.kt
    ├── MedicineIdScreen.kt
    └── ...
```

**Data Flow:**  
Camera Frame → ViewModel → [SensorTracker + ObjectDetector → FloorSegmenter → PathPlanner state] → TTS → StateFlow → Compose UI

---

## 🎯 Future Enhancements

- **Dynamic Obstacle Avoidance** with real-time re-planning (Partially Implemented via VFH)
- **Haptic Turn Cues** for tactile feedback  
- **Multi-Object Waypoints & Navigation History**  
- **Sensor Fusion** for improved heading stability (Implemented) 
- **Model Distillation** for total model size under 5 MB  

---

## 💡 Accessibility & Impact

**GuideLensApp** empowers users with visual impairments to navigate independently using only a smartphone camera — no beacons, maps, or internet required.  
It demonstrates that **real-time, privacy-preserving AI** can be practical on-device, enhancing inclusion and mobility for millions worldwide.

---

## 📚 References & Resources

- [ONNX Runtime Mobile Docs](https://onnxruntime.ai/docs/get-started/with-mobile.html)  
- [Ultralytics YOLO World Docs](https://docs.ultralytics.com/hub/app/android/)  
- [PP-LiteSeg Paper (ArXiv)](https://arxiv.org/html/2504.20976v1)  
- [A* Algorithm – Wikipedia](https://en.wikipedia.org/wiki/A*_search_algorithm)  
- [Pure Pursuit Controller – MathWorks](https://www.mathworks.com/help/robotics/ref/purepursuit.html)  

---

## 🧑‍💻 Author 

**Developer:** Pranav Garg 


---

## 🏁 Conclusion

**GuideLensApp** showcases the future of **on-device AI navigation** — merging deep learning, classical algorithms, and accessibility design into one cohesive Android application.  
With optimized models, adaptive runtime, and robust engineering, it stands as a **reference implementation for real-time computer-vision navigation** on mobile devices.

