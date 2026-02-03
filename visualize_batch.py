import mmap
import ctypes
import cv2
import os
import sys

# Shared memory definitions
SHM_NAME = "/yolo_ipc_shm"
MAX_BOXES = 10

class Detection(ctypes.Structure):
    _fields_ = [
        ("class_id", ctypes.c_int),
        ("confidence", ctypes.c_float),
        ("x", ctypes.c_int),
        ("y", ctypes.c_int),
        ("w", ctypes.c_int),
        ("h", ctypes.c_int),
    ]

class SharedData(ctypes.Structure):
    _fields_ = [
        ("count", ctypes.c_int),
        ("det", Detection * MAX_BOXES),
    ]

def visualize_detections(image_path, output_path):
    """Read detections from shared memory and draw boxes on image"""
    
    # Open shared memory
    fd = os.open("/dev/shm" + SHM_NAME, os.O_RDONLY)
    shm = mmap.mmap(fd, ctypes.sizeof(SharedData), mmap.MAP_SHARED, mmap.PROT_READ)
    shared = SharedData.from_buffer_copy(shm)
    
    print(f"  Detections found: {shared.count}")
    
    # Load image
    img = cv2.imread(image_path)
    if img is None:
        print(f"  Error: Failed to load {image_path}")
        return False
    
    # Draw bounding boxes
    for i in range(shared.count):
        d = shared.det[i]
        x, y, w, h = d.x, d.y, d.w, d.h
        conf = d.confidence
        
        cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)
        label = f"ID:{d.class_id} {conf:.2f}"
        cv2.putText(img, label, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)
    
    # Save result
    cv2.imwrite(output_path, img)
    print(f"  Output saved: {output_path}")
    
    shm.close()
    os.close(fd)
    return True

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 visualize_batch.py <input_image> <output_image>")
        sys.exit(1)
    
    input_image = sys.argv[1]
    output_image = sys.argv[2]
    
    visualize_detections(input_image, output_image)
