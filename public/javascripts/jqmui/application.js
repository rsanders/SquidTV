
(function() {
    // fake list item links
    jQuery('li.clickable').live('click tap', function(ev) {
                jQuery(ev.currentTarget).ajaxClick();
            });

    jQuery('a[data-magic-link=cancel],a[data-magic-link=back]').live('click tap',
                function(ev) {
                    history.back();
                    return false;
                }
            );

    // if we're cached, restart when an update is available
    if (window.applicationCache) {
        window.applicationCache.addEventListener('updateready', function() {
            alert("Update ready - click ok to reload");
            window.applicationCache.swapCache();
            window.location = window.location;
        });
    }

    jQuery('select[name=watched]').live('change', function(event) {
        alert("Slider changed: " + this.value);
    });

})();

