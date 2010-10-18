Ext.regModel('Show', {
    fields: ['id', 'name']
});

Ext.regModel('Episode', {
    fields: ['id', 'title', 'show_name', {name: 'show', type: 'Show'},
        'aired_at', 'season', 'number', 'overview']
});

torv.EpisodeStore = new Ext.data.Store({
    model: 'Episode',
    sorters: 'id',
//    getGroupString : function(record) {
//        return record.get('show_id')[0];
//    },

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

    //alternatively, a Ext.data.Model name can be given (see Ext.data.Store for an example)
    // fields: ['id', 'title'] /*, {name:'size', type: 'float'}, {name:'lastmod', type:'date'}] */
});


torv.EpisodeList = new Ext.List ({
    title: 'Episodes',
    width: Ext.is.Phone ? undefined : 300,
    height: 500,
    xtype: 'list',
    store: torv.EpisodeStore,
    tpl: '<tpl for="."><div class="contact"><strong>{id}</strong> {title}</div></tpl>',
    itemSelector: 'div.contact',
    singleSelect: true,
    grouped: false,
    indexBar: true
});
