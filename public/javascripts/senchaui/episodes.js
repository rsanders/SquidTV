torv.Episode = Ext.regModel('Episode', {
    fields: ['id', 'title', 'show_name', {name: 'show', type: 'Show'},
        'aired_at', 'season', 'number', 'overview', 'time_category'],

    belongsTo: 'Show',

    store: 'episodeStore',

    displayName: function() {
        return this.get('show_name') + " " + this.get('season') + ' ' + this.get('number');
    },

    watch: function() {
        $.ajax({url: '/episodes/' + this.get('id') + '/watch',
                type: 'POST',
                dataType: 'json'
        });
        this.store.remove(this);
    }
});

torv.EpisodeListType = Ext.extend(Ext.List, {
        title: 'Episodes',
        width: Ext.is.Phone ? undefined : 300,
        height: 500,
        xtype: 'list',
        store: torv.EpisodeStore,
        loadingText: 'Loading...',
        // tpl: Ext.XTemplate.from('episode'),
        itemSelector: 'div.episode',
        singleSelect: true,
        grouped: true,
        iconCls: 'user',
        indexBar: false,

        initComponent: function() {
            var list= this;

            torv.EpisodeListType.superclass.initComponent.call(this, arguments);

            this.on('itemswipe', function(list, idx, el, e) {
                list.swipeAction(list, idx, el);
            });

            this.on('itemtap', function(list, idx, el, e) {
                var ds = list.getStore(),
                        r  = ds.getAt(idx);
                list.clearSelections();
                list.showEpisode(r);
            });

            // XXX: another weird hack due to ignorance - we wait until after layout to add a
            //     doubletap listener (otherwise the list isn't in the dom), and since
            //     layout happens often, we guard this with a "static" flag

            this.on('afterlayout', function() {
                if (!list.addedDtapHandler) {
                    Ext.EventManager.addListener(this.id, 'doubletap', function(e) {
                        if (e.pageY < 30) {
                            // fixes bug where old header stayed pinned to top
                            if (list.header) {
                                list.header.hide();
                            }
                            list.scroller.scrollTo(0, 500);
                        }
                    }, this);
                    this.addedDtapHandler = true;
                }
            });
        },

        swipeAction: function(list, idx, el) {
            var ds = list.getStore(),
                    r  = ds.getAt(idx);
            list.showActionSheet({episode: r, list: list, idx: idx, el: el});
            list.clearSelections();
        },

        showEpisode: function(episode) {
            var panel;
            panel = new Ext.Panel({
                fullscreen: true,
                dockedItems: [{
                    dock: 'top',
                    xtype: 'toolbar',
                    type: 'light',
                    items: [new Ext.Button({
                        text: 'Back',
                        ui: 'back',
                        handler: function() { panel.hide({type: 'cube', duration: 400}); },
                        scope: panel})]
                }],
                items: [{xtype: 'panel',
                    fullscreen: true,
                    cls: 'showdetail',
                    tpl: Ext.XTemplate.from('episode_detail'),
                    data: episode.data
                }]
            });
        },

        showActionSheet: function(args) {
            var list = args.list;
            // this.actionArgs = args;
            var actionSheet = new Ext.ActionSheet({
                items: [{
                    text: 'Watch',
                    ui: 'confirm-round',
                    handler : function() {
                        var     // args = list.actionArgs,
                                episode = args.episode;
                        episode.watch();
                        list.clearSelections();
                        actionSheet.hide();
                    }
                },{
                    text : 'Cancel',
                    ui: 'decline',
                    handler : function(){
                        actionSheet.hide();
                    }
                }]
            });

            actionSheet.show();
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

    torv.EpisodeList = new torv.EpisodeListType ({
        title: 'Episodes',
        store: torv.EpisodeStore,
        loadingText: 'Loading...',
        tpl: Ext.XTemplate.from('episode')
    });
};
