#!/bin/bash

# Bu script, flavorizr çalıştırıldıktan sonra NotificationServiceExtension için doğru bundle ID'leri ayarlar

echo "Updating NotificationServiceExtension bundle IDs..."

# Proje dizinini al
PROJECT_DIR="$(pwd)"
IOS_DIR="$PROJECT_DIR/ios"
FLUTTER_DIR="$IOS_DIR/Flutter"

# flavorizr.yaml dosyasını oku ve her flavor için NotificationServiceExtension bundle ID'sini ayarla
FLAVORS=$(grep -A 10 "flavors:" "$PROJECT_DIR/flavorizr.yaml" | grep -E "^  [a-zA-Z0-9_-]+:" | sed 's/://g' | awk '{print $1}')

for FLAVOR in $FLAVORS; do
  # flavor ios.bundleId değerini al
  BUNDLE_ID=$(grep -A 20 "$FLAVOR:" "$PROJECT_DIR/flavorizr.yaml" | grep "bundleId:" | head -1 | cut -d'"' -f2)
  
  if [ -n "$BUNDLE_ID" ]; then
    EXTENSION_BUNDLE_ID="${BUNDLE_ID}.NotificationServiceExtension"
    
    # Her konfigürasyon dosyasını güncelle
    for CONFIG_FILE in "$FLUTTER_DIR/${FLAVOR}"*.xcconfig; do
      if [ -f "$CONFIG_FILE" ]; then
        # NOTIFICATION_EXTENSION_BUNDLE_ID var mı kontrol et ve güncelle
        if grep -q "NOTIFICATION_EXTENSION_BUNDLE_ID" "$CONFIG_FILE"; then
          sed -i '' "s|NOTIFICATION_EXTENSION_BUNDLE_ID=.*|NOTIFICATION_EXTENSION_BUNDLE_ID=${EXTENSION_BUNDLE_ID}|g" "$CONFIG_FILE"
        else
          echo "NOTIFICATION_EXTENSION_BUNDLE_ID=${EXTENSION_BUNDLE_ID}" >> "$CONFIG_FILE"
        fi
        echo "Updated $CONFIG_FILE with extension bundle ID: $EXTENSION_BUNDLE_ID"
      fi
    done
  fi
done

echo "NotificationServiceExtension bundle IDs updated successfully!"