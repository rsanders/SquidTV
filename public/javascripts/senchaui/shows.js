/**
 * Created by IntelliJ IDEA.
 * User: robertsanders
 * Date: 10/19/10
 * Time: 12:11 AM
 * To change this template use File | Settings | File Templates.
 */
torv.Show = Ext.regModel('Show', {
    fields: ['id', 'name', 'created_at', 'unwatched_episode_count', 'episodes_count', 'url',
        'latest_unwatched_episode_at', 'first_aired_at', 'runtime', 'latest_episode_at', 'tvdb_id',
        'season_count', 'genre', 'overview', 'sortable_name'],

    store: 'showStore',

    hasMany: 'Episode'
});

torv.Main.initShowList = function () {
    torv.ShowStore = new Ext.data.Store({
        model: 'Show',

        // store configs
        autoLoad: true,
        autoDestroy: true,
        storeId: 'showStore',

        getGroupString : function(record) {
            return record.get('sortable_name').substring(0,1).toUpperCase();
        },

        proxy: {
            type: 'ajax',
            url: '/shows.json',
            reader: {
                type: 'json'
            }
        }
    });

    torv.ShowList = new Ext.List ({
        title: 'Shows',
        width: Ext.is.Phone ? undefined : 300,
        height: 500,
        xtype: 'list',
        store: torv.ShowStore,
        // loadingText: 'Loading...',
        tpl: Ext.XTemplate.from('show'),
        itemSelector: 'div.show',
        singleSelect: true,
        grouped: true,
        iconCls: 'favorites',
        indexBar: true
    });

    torv.ShowList.on('itemtap', function(list, idx, el, e) {
        var ds = list.getStore(),
            r  = ds.getAt(idx);
        alert("Tapped on leaf! " + r.get('name') );
        list.clearSelections();
    });
};
