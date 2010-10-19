/**
 * Created by IntelliJ IDEA.
 * User: robertsanders
 * Date: 10/19/10
 * Time: 12:11 AM
 * To change this template use File | Settings | File Templates.
 */

Ext.regModel('Show', {
    fields: ['id', 'name', 'created_at', 'unwatched_episode_count', 'episodes_count', 'url',
        'latest_unwatched_episode_at', 'first_aired_at', 'runtime', 'latest_episode_at', 'tvdb_id',
        'season_count', 'genre', 'overview', 'sortable_name']
});

torv.ShowStore = new Ext.data.Store({
    model: 'Show',

    // store configs
    autoLoad: true,
    autoDestroy: true,
    storeId: 'showStore',
    getGroupString : function(record) {
        return record.get('name').substring(0,1);
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
    tpl: '<tpl for="."><div class="show"><h3>{name}</h3>' +
            '<span class="episode_number">{unwatched_episode_count}</span>' +
            '</div></tpl>',
    itemSelector: 'div.show',
    singleSelect: true,
    grouped: true,
    iconCls: 'favorites',
    indexBar: true

//    disclosure: {
//        scope: 'test',
//        handler: function(record, btn, index) {
//            alert('Disclose more info for ' + record.get('name'));
//        }
//    }
});

torv.ShowList.on('itemtap', function(list, idx, el, e, detailCard) {
    var ds = list.getStore(),
        r  = ds.getAt(idx);
    alert("Tapped on leaf! " + r.get('name') );
    list.clearSelections();
});
