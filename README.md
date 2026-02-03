# YOLO IPC Detection System

## Overview
This project demonstrates **Inter-Process Communication (IPC)** using POSIX shared memory between a C program (YOLO object detection) and a Python program (visualization).

## System Architecture

```
┌─────────────────────┐         ┌──────────────────────┐         ┌─────────────────────┐
│   C Program         │         │  Shared Memory       │         │  Python Program     │
│   (yolo_ipc)        │────────▶│  /dev/shm/           │────────▶│  (visualize_batch)  │
│                     │  write  │  yolo_ipc_shm        │  read   │                     │
│ - Load YOLO model   │         │                      │         │ - Read detections   │
│ - Process image     │         │ Contains:            │         │ - Draw bounding box │
│ - Detect objects    │         │ - Detection count    │         │ - Save output       │
│ - Write results     │         │ - Bounding boxes     │         │                     │
└─────────────────────┘         │ - Confidence scores  │         └─────────────────────┘
                                └──────────────────────┘
```

## Files

### Core Files
- **`yolo_ipc.c`** - C program for YOLO object detection
- **`yolo_ipc`** - Compiled binary
- **`visualize_batch.py`** - Python script for visualization
- **`run_all.sh`** - Script to process multiple images

### Model Files
- **`yolov4-tiny.cfg`** - YOLO model configuration
- **`yolov4-tiny.weights`** - Pre-trained model weights
- **`coco.names`** - Object class names (80 classes)

### Test Images
- `picture1.jpg`, `picture2.jpg`, `picture3.jpg`

## Requirements

### System
- Linux/WSL (for POSIX shared memory)
- GCC compiler
- Python 3

### Libraries
- OpenCV (for Python)
- Darknet library (included)

## How to Run

### Process All Images
```bash
cd /mnt/e/4-2/embedded/IPC_Assignment/darknet
chmod +x run_all.sh
./run_all.sh
```

### Process Single Image
```bash
# Step 1: Run detection (C program)
./yolo_ipc picture1.jpg

# Step 2: Visualize (Python program)
python3 visualize_batch.py picture1.jpg results/picture1_output.jpg

# Step 3: Cleanup
rm -f /dev/shm/yolo_ipc_shm
```

## Output
- Results are saved in the `results/` directory
- Format: `<original_name>_output.jpg`
- Bounding boxes are drawn in green with confidence scores

## IPC Mechanism

### Shared Memory Structure
```c
typedef struct {
    int class_id;
    float confidence;
    int x, y, w, h;   // bounding box coordinates
} Detection;

typedef struct {
    int count;
    Detection det[MAX_BOXES];
} SharedData;
```

### Communication Flow
1. **C Program** creates shared memory at `/dev/shm/yolo_ipc_shm`
2. **C Program** writes detection results to shared memory
3. **Python Program** reads detection results from shared memory
4. **Python Program** draws bounding boxes and saves output
5. Shared memory is cleaned up after use

## Compilation

To recompile the C program:
```bash
make clean
make
gcc -o yolo_ipc yolo_ipc.c -I./include -L. -ldarknet -lm -pthread
```

## Author
Embedded Systems IPC Assignment
