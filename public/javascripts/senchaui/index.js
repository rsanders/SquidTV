Ext.ns('torv', 'Ext.ux');

torv.Main = {
    init : function() {
        torv.Main.initEpisodeList();
        torv.Main.initShowList();

        torv.TabPanel = new Ext.TabPanel({
            fullscreen: true,
            sortable: false,
            tabBar: {
                dock: 'bottom',
                layout: {
                    pack: 'center'
                }
            },
            ui: 'light',

            defaults: {
                scroll: 'vertical'
            },
            items: [torv.EpisodeList, torv.ShowList]
        });
    },

    showPopup: function(message) {
        var popup = new Ext.Panel({
                    floating: true,
                    modal: true,
                    centered: true,
                    width: 300,
                    styleHtmlContent: true,
                    html: '<p>' + message + '</p>',
                    dockedItems: [{
                        dock: 'top',
                        xtype: 'toolbar',
                        title: 'Message'
                    }],
                    scroll: 'vertical'
                });
            popup.show('pop');
    }  

};

Ext.setup({
    tabletStartupScreen: '/images/tablet_startup.png',
    phoneStartupScreen: '/images/phone_startup.png',
    icon: '/images/icon.png',
    glossOnIcon: false,

    onReady: function() {
        torv.Main.init();
    }
});

if (window.applicationCache) {
    window.applicationCache.addEventListener('updateready', function() {
        alert("Update ready - click ok to reload");
        window.location = window.location;
    });
}
