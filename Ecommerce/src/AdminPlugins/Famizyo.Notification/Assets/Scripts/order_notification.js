
const toastTemplate = ` 
    <div role="alert" aria-live="assertive" aria-atomic="true" class="toast bg-warning red" data-autohide="false" style="min-width: 20vw">
      <div class="toast-header">
        <img src="/_content/Grand.SharedUIResources/administration/build/images/famizyoLogo.png" class="rounded mr-2" alt="famizyo">
        <strong class="mr-auto">Famizyo</strong>
        <button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="toast-body" style="cursor: pointer">
        Yeni bir siparişiniz var.
      </div>
    </div>
    `;
const _this = {
    notifications: [],
    audioPermissionGranted: false
};

// Check if audio context is available
const AudioContext = window.AudioContext || window.webkitAudioContext;
let audioContext;

// Check and store notification permission
function checkAudioPermission() {
    // Try to create audio context to check if audio is allowed
    try {
        if (AudioContext) {
            audioContext = new AudioContext();
            
            // If the state is suspended, user needs to interact with the page
            if (audioContext.state === 'suspended') {
                _this.audioPermissionGranted = false;
                return false;
            } else {
                _this.audioPermissionGranted = true;
                return true;
            }
        }
    } catch (e) {
        console.error("Audio context couldn't be created:", e);
        _this.audioPermissionGranted = false;
        return false;
    }
    
    // Default fallback if audio context couldn't be checked
    _this.audioPermissionGranted = false;
    return false;
}

// Request audio permission
function requestAudioPermission() {
    try {
        if (audioContext && audioContext.state === 'suspended') {
            audioContext.resume().then(() => {
                _this.audioPermissionGranted = true;
                // Test audio to confirm permission
                notifyPlayTest();
            }).catch(error => {
                console.error('Failed to resume audio context:', error);
                _this.audioPermissionGranted = false;
            });
        } else if (!audioContext && AudioContext) {
            // Create a new audio context
            audioContext = new AudioContext();
            
            // Create a short "silent" sound to test permission
            const oscillator = audioContext.createOscillator();
            oscillator.connect(audioContext.destination);
            oscillator.start();
            oscillator.stop(audioContext.currentTime + 0.001);
            
            _this.audioPermissionGranted = true;
            
            // Test audio to confirm permission
            notifyPlayTest();
        }
    } catch (e) {
        console.error("Error requesting audio permission:", e);
        _this.audioPermissionGranted = false;
    }
}

function showPermissionDialog() {
    // Show the modal dialog
    $('#notificationPermissionModal').modal('show');
}

// Test audio notification with minimal volume
function notifyPlayTest() {
    let audioElem = document.getElementById("orderAudio");
    
    // Set very low volume for the test
    const originalVolume = audioElem.volume;
    audioElem.volume = 0.1;
    
    // Play a short test sound
    audioElem.currentTime = 0;
    audioElem.muted = false;
    
    let playPromise = audioElem.play();
    if (playPromise) {
        playPromise.then(() => {
            // Success - permission granted
            _this.audioPermissionGranted = true;
            
            // Pause quickly after confirming it works
            setTimeout(() => {
                audioElem.pause();
                audioElem.currentTime = 0;
                audioElem.volume = originalVolume;
            }, 500);
            
            // Store permission in localStorage
            localStorage.setItem('audioPermissionGranted', 'true');
            
            // Close the dialog if it's open
            $('#notificationPermissionModal').modal('hide');
        }).catch(err => {
            console.error("Audio permission test failed:", err);
            _this.audioPermissionGranted = false;
        });
    }
}

function notifyPlay() {
    // Check permission before playing
    if (!_this.audioPermissionGranted) {
        showPermissionDialog();
        return;
    }
    
    let audioElem = document.getElementById("orderAudio");
    // audioElem.stop();
    audioElem.currentTime = 0;
    audioElem.muted = false;
    let playedPromise = audioElem.play();
    if (playedPromise) {
        playedPromise.then(() => {
            if (_this.notifications.length > 0) {
                setTimeout(function () {
                    notifyPlay();
                }, 1000);
            }
        }).catch((err) => {
            console.log(err);
            // If permission denied, update status and show dialog
            _this.audioPermissionGranted = false;
            showPermissionDialog();
        });
    }
}

document.addEventListener("DOMContentLoaded", function () {
    // Set up AJAX defaults for notification tracking
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('input[name="__RequestVerificationToken"]').val()
        },
        xhrFields: {
            withCredentials: true
        }
    });
    
    // Check stored permission
    if (localStorage.getItem('audioPermissionGranted') === 'true') {
        _this.audioPermissionGranted = true;
    } else {
        // Check current permission
        _this.audioPermissionGranted = checkAudioPermission();
        
        // Show permission dialog on first load if permission not granted
        if (!_this.audioPermissionGranted) {
            // Show dialog after a short delay to ensure UI is ready
            setTimeout(() => {
                showPermissionDialog();
            }, 2000);
        }
    }
    
    // Set up event listener for permission button
    $('#requestNotificationPermission').on('click', function() {
        requestAudioPermission();
    });
    const toastStackTemplate= `
    <div aria-live="polite" aria-atomic="true" style="position: absolute; min-height: 200px;top: 20px;right: 10px;z-index: 99999;max-height: 90%;overflow: scroll;">
        <!-- Position it -->
        <div id="toast-stack" style="position: relative; top: 0; right: 0;">
        </div>
    </div>
    `;
    $('body').prepend(toastStackTemplate);
    
    const connection = new signalR.HubConnectionBuilder()
        .withUrl("/notificationhub")
        .configureLogging(signalR.LogLevel.Error)
        .build();

    async function start() {
        try {
            await connection.start();
            console.log("SignalR Connected.");
        } catch (err) {
            console.log(err);
            setTimeout(start, 5000);
        }
    }

    connection.onclose(async () => {
        await start();
    });

    connection.on("NewOrder", function (orderId, notificationId) {
        // Handle the new order notification here
        console.log("New order received: " + orderId + ", notification ID: " + notificationId);
        
        // Create toast with both order ID and notification ID data
        let newToast = $(toastTemplate);
        newToast.attr('id', orderId);
        newToast.attr('data-notification-id', notificationId);
        $('#toast-stack').prepend(newToast);
        
        // When toast is shown, mark as viewed and play notification sound
        $('#'+orderId).on('shown.bs.toast', function () {
            // Mark notification as viewed when toast is shown using AJAX
            $.ajax({
                url: '/Admin/Notification/MarkAsViewed',
                type: 'POST',
                data: { notificationId: notificationId },
                success: function(response) {
                    console.log('Notification marked as viewed');
                },
                error: function(xhr, status, error) {
                    console.error("Error marking notification as viewed: " + error);
                }
            });
            
            // Add to notifications array for sound
            if (_this.notifications && !_this.notifications.some(function (notification) {
                return notification === orderId;
            })) {
                _this.notifications.push(orderId);
                $("#notify-button").trigger("click");
                return;
            }

            _this.notifications = [
                orderId
            ];

            $("#notify-button").trigger("click");
        });
        
        // When toast is closed (hidden)
        $('#'+orderId).on('hidden.bs.toast', function () {
            if (_this.notifications) {
                if (_this.notifications && _this.notifications.length > 0) {
                    _this.notifications.pop();
                }

                if (_this.notifications.length == 0) {
                    //stopSound();
                }
            }

            $('#'+orderId).toast('dispose');

            // Mark notification as interacted with when toast is closed using AJAX
            $.ajax({
                url: '/Admin/Notification/MarkAsInteracted',
                type: 'POST',
                data: { notificationId: notificationId },
                success: function(response) {
                    console.log('Notification marked as interacted with on hide');
                },
                error: function(xhr, status, error) {
                    console.error("Error marking notification as interacted with: " + error);
                }
            });
        });

        // When user clicks on the notification to go to the order
        $('#'+orderId+' .toast-body').on('click', function () {
            // Mark notification as interacted with using AJAX
            $.ajax({
                url: '/Admin/Notification/MarkAsInteracted',
                type: 'POST',
                data: { notificationId: notificationId },
                success: function(response) {
                    console.log('Notification marked as interacted with on click');
                },
                error: function(xhr, status, error) {
                    console.error("Error marking notification as interacted with: " + error);
                }
            }).then((response) => {
                if (_this.notifications) {
                    _this.notifications.pop();
                }

                // Navigate to order details
                window.location.href = "/Admin/Order/Edit/"+ orderId;
            });
        });

        $('#'+orderId).toast('show');
    }); 

// Start the connection.
    start();
});