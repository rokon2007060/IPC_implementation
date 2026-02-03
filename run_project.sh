#!/bin/bash

# IPC Assignment - YOLO Object Detection with Shared Memory
# This script runs the complete workflow

echo "========================================="
echo "YOLO IPC Object Detection Project"
echo "========================================="
echo ""

# Change to project directory
cd "$(dirname "$0")"

# Check if required files exist
echo "[1/4] Checking required files..."
if [ ! -f "yolo_ipc" ]; then
    echo "Error: yolo_ipc binary not found!"
    exit 1
fi

if [ ! -f "yolov4-tiny.weights" ]; then
    echo "Error: yolov4-tiny.weights not found!"
    exit 1
fi

if [ ! -f "test-image.jpg" ]; then
    echo "Error: test-image.jpg not found!"
    exit 1
fi

echo "✓ All required files found"
echo ""

# Clean up any previous shared memory
echo "[2/4] Cleaning previous shared memory..."
rm -f /dev/shm/yolo_ipc_shm
echo "✓ Cleaned"
echo ""

# Run YOLO detection (C program)
echo "[3/4] Running YOLO detection..."
./yolo_ipc test-image.jpg
if [ $? -ne 0 ]; then
    echo "Error: YOLO detection failed!"
    exit 1
fi
echo ""

# Run Python visualization
echo "[4/4] Running visualization..."
python3 visualize.py
if [ $? -ne 0 ]; then
    echo "Error: Visualization failed!"
    exit 1
fi

echo ""
echo "========================================="
echo "✓ Process Complete!"
echo "========================================="
echo "Output saved as: ipc_output.jpg"
echo ""
