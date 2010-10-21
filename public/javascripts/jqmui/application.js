
jQuery('.episode').live('click', function(ev) {
    // jQuery(ev.currentTarget).slideUp();
    jQuery(ev.currentTarget).ajaxClick();
});

if (window.applicationCache) {
    window.applicationCache.addEventListener('updateready', function() {
        alert("Update ready - click ok to reload2");
        window.applicationCache.swapCache();
        window.location = window.location;
    });
}
