Ext.ns('torv', 'Ext.ux');

torv.Main = {
    init : function() {
        new Ext.TabPanel({
            fullscreen: true,
            // type: 'dark',
            sortable: false,
            tabBar: {
                dock: 'bottom',
                layout: {
                    pack: 'center'
                }
            },
            ui: 'light',
//            animation: {
//                type: 'cardslide',
//                cover: true
//            },

            defaults: {
                scroll: 'vertical'
            },
            items: [torv.EpisodeList
            , {
                    iconCls: 'download',
                title: 'Shows',
                html: '2',
                cls: 'card2'
            }, {
                    iconCls: 'favorites',
                title: 'Files',
                html: '3',
                cls: 'card3'
            }]
        });

        // torv.EpisodeList.show();
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
