Ext.regModel('Show', {
    fields: ['id', 'name']
});

Ext.regModel('Episode', {
    fields: ['id', 'title', 'show_name', {name: 'show', type: 'Show'},
        'aired_at', 'season', 'number', 'overview', 'time_category']
});

torv.EpisodeStore = new Ext.data.Store({
    model: 'Episode',
    sorters: 'id',
    getGroupString : function(record) {
        return record.get('time_category');
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
//        reader: {
//            type: 'json',
//            root: 'images',
//            idProperty: 'id'
//        }
    }
});


torv.EpisodeList = new Ext.List ({
    title: 'Episodes',
    width: Ext.is.Phone ? undefined : 300,
    height: 500,
    xtype: 'list',
    store: torv.EpisodeStore,
    tpl: '<tpl for="."><div class="episode"><h3>{show_name}</h3>' +
            '<span class="episode_number">{season} - {number}</span>' +
            '<h4 class="title">{title}</h4>' +
            '<p class="overview">{overview}</p>' +
            '</div></tpl>',
    itemSelector: 'div.episode',
    singleSelect: true,
    grouped: true,
    iconCls: 'user',
    indexBar: false
});
