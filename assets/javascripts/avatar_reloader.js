// avatar_reloader.js

(function($) {
  // 1. Event Handler
  // Use a class selector to attach the handler unobtrusively
  $(document).on('click', '#avatar-reload-link', function(event) {
    event.preventDefault();
    var $link = $(this);
    var deleteUrl = $link.data('deleteUrl'); 
    
    // Disable the link during the AJAX call
    $link.html('Loading...').prop('disabled', true);
    
    // Call the function that handles the AJAX post
    reloadAvatar(deleteUrl, $link);
  });

  // 2. AJAX Function
  var reloadAvatar = function(deleteUrl, $link) {
    // Note: The structure for checking the response (data.deleted) depends on 
    // how you modernized the 'delete' action in PicturesController.
    // Assuming the modernized controller returns { deleted: true/false }
    
    $.ajax({
      url: deleteUrl,
      type: 'DELETE', // Use standard HTTP DELETE method
      dataType: 'json'
    })
    .done(function(data) {
      // Pass the boolean result (data.deleted) to the message handler
      reloadAvatarMessage(data.deleted, $link); 
    })
    .fail(function() {
      // Handle network errors or server failures
      reloadAvatarMessage(false, $link); 
    });
  };

  // 3. Status/Message Handler
  var reloadAvatarMessage = function(success, $link) {
    var $avatarDiv = $link.closest('#avatar');

    if (success) {
      // Clear the link and append a status message
      $link.remove();
      $avatarDiv.append('<strong style="color: green">reloaded</strong>');
    } else {
      // Restore the link text and show failure message
      $link.html('Try again.').prop('disabled', false);
      $avatarDiv.prepend('<strong style="color: red">Failed</strong>.&nbsp;');
    }
  };
})(jQuery); 
// Ensure this script is loaded after jQuery (which Redmine includes)