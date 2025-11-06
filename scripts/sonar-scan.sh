#!/bin/bash

echo "Starting SonarQube Scan..."

# Install sonar-scanner if not exists
if ! command -v sonar-scanner &> /dev/null; then
    echo "Installing sonar-scanner..."
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
    unzip sonar-scanner-cli-4.8.0.2856-linux.zip
    export PATH=$PWD/sonar-scanner-4.8.0.2856-linux/bin:$PATH
fi

# Scan patient-service
echo "Scanning patient-service..."
cd patient-service
sonar-scanner \
  -Dsonar.projectKey=patient-service \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.login=$SONAR_TOKEN \
  -Dsonar.coverage.exclusions=**/node_modules/**,**/test/** \
  -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info

# Scan appointment-service
echo "Scanning appointment-service..."
cd ../appointment-service
sonar-scanner \
  -Dsonar.projectKey=appointment-service \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.login=$SONAR_TOKEN \
  -Dsonar.coverage.exclusions=**/node_modules/**,**/test/** \
  -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info

echo "SonarQube Scan completed."