#!/bin/bash

echo "Starting Trivy Vulnerability Scan..."

# Install trivy if not exists
if ! command -v trivy &> /dev/null; then
    echo "Installing trivy..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

# Function to scan image
scan_image() {
    local image_name=$1
    local image_tag=$2
    
    echo "Scanning image: $image_name:$image_tag"
    
    # Run trivy scan
    trivy image \
        --format sarif \
        --output "trivy-results-${image_name}.sarif" \
        "$ACR_LOGIN_SERVER/$image_name:$image_tag"
    
    # Check for critical vulnerabilities
    local critical_vulns=$(trivy image --severity CRITICAL "$ACR_LOGIN_SERVER/$image_name:$image_tag" | grep -c "CRITICAL" || true)
    
    if [ "$critical_vulns" -gt 0 ]; then
        echo "CRITICAL: Found $critical_vulns critical vulnerabilities in $image_name"
        exit 1
    else
        echo "No critical vulnerabilities found in $image_name"
    fi
}

# Scan both services
scan_image "patient-service" "latest"
scan_image "appointment-service" "latest"

echo "Trivy Scan completed successfully."