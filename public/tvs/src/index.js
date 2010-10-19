Ext.ns('torv', 'Ext.ux');

torv.Main = {
    init : function() {
        new Ext.TabPanel({
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
    }
};

Ext.setup({
    tabletStartupScreen: '../resources/img/tablet_startup.png',
    phoneStartupScreen: '../resources/img/phone_startup.png',
    icon: '../resources/img/icon.png',
    glossOnIcon: false,

    onReady: function() {
        torv.Main.init();
    }
});
