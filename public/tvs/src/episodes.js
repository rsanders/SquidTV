torv.Episode = Ext.regModel('Episode', {
    fields: ['id', 'title', 'show_name', {name: 'show', type: 'Show'},
        'aired_at', 'season', 'number', 'overview', 'time_category'],

    belongsTo: 'Show',

    store: 'episodeStore',

    displayName: function() {
        return this.get('show_name') + " " + this.get('season') + ' ' + this.get('number');
    },

    watch: function() {
        this.store.remove(this);
    }
});

torv.Main.initEpisodeList = function() {
    torv.EpisodeStore = new Ext.data.Store({
        model: 'Episode',
        // sorters: 'aired_at',
        getGroupString : function(record) {
            return 'Aired ' + record.get('time_category') + ' ago'
        },

        // store configs
        autoLoad: true,
        autoDestroy: true,
        storeId: 'episodeStore',

        proxy: {
            type: 'ajax',
            url: '/episodes.json',
            reader: {
                type: 'json'
            }
        }
    });


    torv.EpisodeList = new Ext.List ({
        title: 'Episodes',
        width: Ext.is.Phone ? undefined : 300,
        height: 500,
        xtype: 'list',
        store: torv.EpisodeStore,
        loadingText: 'Loading...',
        tpl: Ext.XTemplate.from('episode'),
        itemSelector: 'div.episode',
        singleSelect: true,
        grouped: true,
        iconCls: 'user',
        indexBar: false,

        swipeAction: function(list, idx, el) {
            var ds = list.getStore(),
                    r  = ds.getAt(idx);
            this.actions.args = {episode: r, list: list, idx: idx, el: el};
            this.actions.show();
            list.clearSelections();
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
        },

        actions: new Ext.ActionSheet({
                        items: [{
                            text: 'Watch',
                            ui: 'decline',
                            handler : function() {
                                var     args = torv.EpisodeList.actions.args,
                                        episode = args.episode;
                                torv.EpisodeList.showPopup("Watched " + episode.displayName());
                                episode.watch();
                                torv.EpisodeList.clearSelections();
                                torv.EpisodeList.actions.hide();
                            }
                        },{
                            text : 'Cancel',
                            ui: 'confirm',
                            handler : function(){
                                torv.EpisodeList.actions.hide();
                            }
                        }]
        })

    });

    torv.EpisodeList.on('itemswipe', function(list, idx, el, e) {

        list.swipeAction(list, idx, el);
    });
};
