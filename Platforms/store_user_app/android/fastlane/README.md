# Fastlane Android Setup

This directory contains the Fastlane configuration for Android app deployment.

## Prerequisites

1. **Google Play Console Service Account**
   - Create a service account in Google Cloud Console
   - Enable Google Play Android Developer API
   - Create and download a JSON key for the service account
   - Grant the service account access to your app in Google Play Console

2. **Environment Variables**
   Set the following environment variables before running Fastlane:

   ```bash
   # Required for all deployments
   export GOOGLE_PLAY_JSON_KEY_PATH="/path/to/your/service-account-key.json"
   export VERSION_NAME="1.0.0"
   export VERSION_CODE="1"
   
   # Optional - defaults to asksekerle flavor
   export FLAVOR="asksekerle"
   
   # Optional - defaults to com.famizyo.[flavor]
   export PACKAGE_NAME="com.famizyo.asksekerle"
   ```

## Available Lanes

### 1. Beta Deployment
Deploy to Google Play Beta track:

```bash
# Using environment variables
fastlane beta

# Or pass flavor as parameter
fastlane beta flavor:asksekerle
```

### 2. Production Deployment
Deploy to Google Play Production track:

```bash
# Using environment variables
fastlane production

# Or pass flavor as parameter
fastlane production flavor:asksekerle
```

### 3. Build Only
Build AAB without uploading:

```bash
# Using environment variables
fastlane build

# Or pass flavor as parameter
fastlane build flavor:asksekerle
```

### 4. Validate Setup
Validate Google Play Store connection:

```bash
fastlane validate_play_store
```

## Example Usage

```bash
# Set up environment variables
export GOOGLE_PLAY_JSON_KEY_PATH="~/keys/play-store-key.json"
export VERSION_NAME="1.2.0"
export VERSION_CODE="120"
export FLAVOR="asksekerle"

# Deploy to beta
cd android
fastlane beta

# Or use a one-liner
GOOGLE_PLAY_JSON_KEY_PATH=~/keys/play-store-key.json VERSION_NAME=1.2.0 VERSION_CODE=120 fastlane beta flavor:asksekerle
```

## Notes

- The lanes will build a release AAB (Android App Bundle) automatically
- Uploads are created as drafts by default - review and release manually in Play Console
- To auto-release, change `release_status: "draft"` to `release_status: "completed"` in the Fastfile
- The AAB will be generated at: `build/app/outputs/bundle/[flavor]Release/app-[flavor]-release.aab`

## Troubleshooting

1. **Authentication Error**
   - Ensure the service account has the correct permissions in Google Play Console
   - Verify the JSON key file path is correct

2. **Build Errors**
   - Ensure you have a valid `key.properties` file for release signing
   - Run `flutter clean` before building

3. **Version Code Issues**
   - Version code must be higher than the current version in Play Store
   - Version code must be an integer