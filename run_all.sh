#!/bin/bash

echo "=========================================="
echo "YOLO IPC Detection System"
echo "=========================================="

# Create results directory
mkdir -p results

# Array of images to process
images=("picture1.jpg" "picture2.jpg" "picture3.jpg")

# Process each image
for img in "${images[@]}"; do
    if [ ! -f "$img" ]; then
        echo "Error: $img not found!"
        continue
    fi
    
    echo ""
    echo "Processing $img..."
    
    # Extract base name
    base_name="${img%.*}"
    output_file="results/${base_name}_output.jpg"
    
    # Run YOLO detection (writes to shared memory)
    ./yolo_ipc "$img"
    
    if [ $? -eq 0 ]; then
        # Run visualization (reads from shared memory)
        python3 visualize_batch.py "$img" "$output_file"
        echo "✓ Completed $img"
    else
        echo "✗ Failed to process $img"
    fi
done

# Cleanup shared memory
rm -f /dev/shm/yolo_ipc_shm

echo ""
echo "=========================================="
echo "Processing complete!"
echo "Results saved in ./results/ directory"
echo "=========================================="
