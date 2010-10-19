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

        actions: new Ext.ActionSheet({
                        items: [{
                            text: 'Watch',
                            ui: 'decline',
                            handler : function() {
                                var     args = torv.EpisodeList.actions.args,
                                        episode = args.episode;
                                // torv.EpisodeList.showPopup("Watched " + episode.displayName());
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

    torv.EpisodeList.on('containertap', function(list, e) {
        var elapsed = 9999999;
        if (this.lastTap) {
            elapsed = e.time - this.lastTap;
            console.log("elapsed: " + elapsed);
        }
        this.lastTap = e.time;
        if (e.pageY < 30 && elapsed < 500) {
            alert("Tap to top: " + elapsed);
            this.lastTap = null;
        }
    });

    // XXX: another weird hack dueto ignorance - we wait until after layout to add a
    //     doubletap listener (otherwise the list isn't in the dom), and since
    //     layout happens often, we guard this with a "static" flag

    torv.EpisodeList.on('afterlayout', function() {
        if (!this.addedDtapHandler) {
            Ext.EventManager.addListener(this.id, 'doubletap', function(e) {
                var list = this;
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

};
