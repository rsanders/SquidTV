sink.Structure = [{
    text: 'User Interface',
    cls: 'launchscreen',
    items: [{
        text: 'Buttons',
        card: demos.Buttons,
        source: 'src/demos/buttons.js',
        leaf: true
    },
    {
        text: 'Forms',
        card: demos.Forms,
        source: 'src/demos/forms.js',
        leaf: true
    },
    {
        text: 'List',
        card: demos.List,
        source: 'src/demos/list.js',
        leaf: true
    },
    {
        text: 'Nested List',
        card: demos.NestedList,
        source: 'src/demos/nestedlist.js',
        leaf: true
    },
    {
        text: 'Icons',
        card: demos.Icons,
        source: 'src/demos/icons.js',
        leaf: true
    },
    {
        text: 'Toolbars',
        card: demos.Toolbars,
        source: 'src/demos/toolbars.js',
        leaf: true
    },
    {
        text: 'Carousel',
        card: demos.Carousel,
        source: 'src/demos/carousel.js',
        leaf: true
    },
    {
        text: 'Tabs',
        card: demos.Tabs,
        source: 'src/demos/tabs.js',
        leaf: true
    },
    {
        text: 'Bottom Tabs',
        card: demos.BottomTabs,
        source: 'src/demos/bottomtabs.js',
        leaf: true
    },
    /*{
        text: 'Picker',
        card: demos.Picker,
        source: 'src/demos/picker.js',
        leaf: true
    },*/
    {
        text: 'Map',
        card: demos.Map,
        source: 'src/demos/map.js',
        leaf: true
    },
    {
        text: 'Sheets &amp; Overlays',
        card: demos.SheetsOverlays,
        source: 'src/demos/sheets_overlays.js',
        leaf: true
    }]
},
{
    text: 'Animations',
    source: 'src/demos/animations.js',
    card: Ext.is.Phone ? false : demos.Animations,
    items: [{
        text: 'Slide',
        card: demos.Animations.slide,
        preventHide: true,
        animation: 'slide',
        leaf: true
    },
    {
        text: 'Slide (cover)',
        card: demos.Animations.slidecover,
        preventHide: true,
        animation: {
            type: 'slide',
            cover: true
        },
        leaf: true
    },
    {
        text: 'Slide (reveal)',
        card: demos.Animations.slidereveal,
        preventHide: true,
        animation: {
            type: 'slide',
            reveal: true
        },
        leaf: true
    },
    {
        text: 'Pop',
        card: demos.Animations.pop,
        preventHide: true,
        animation: {
            type: 'pop',
            scaleOnExit: true
        },
        leaf: true
    },
    {
        text: 'Fade',
        card: demos.Animations.fade,
        preventHide: true,
        animation: {
            type: 'fade',
            duration: 600
        },
        leaf: true
    },
    {
        text: 'Flip',
        card: demos.Animations.flip,
        preventHide: true,
        animation: {
            type: 'flip',
            duration: 400
        },
        leaf: true
    },
    {
        text: 'Cube',
        card: demos.Animations.cube,
        preventHide: true,
        animation: {
            type: 'cube',
            duration: 400
        },
        leaf: true
    }]
},
{
    text: 'Touch Events',
    card: demos.Touch,
    source: 'src/demos/touch.js',
    leaf: true
},
{
    text: 'Data',
    card: demos.Data,
    source: 'src/demos/data.js',
    leaf: true
},
{
    text: 'Media',
    items: [{
        text: 'Video',
        card: demos.Video,
        source: 'src/demos/video.js',
        leaf: true
    }, {
        text: 'Audio',
        card: demos.Audio,
        source: 'src/demos/audio.js',
        leaf: true
    }]
}];

Ext.regModel('Demo', {
    fields: [
        {name: 'text',        type: 'string'},
        {name: 'source',      type: 'string'},
        {name: 'preventHide', type: 'boolean'},
        {name: 'animation'},
        {name: 'card'}
    ]
});

sink.StructureStore = new Ext.data.TreeStore({
    model: 'Demo',
    root: {
        items: sink.Structure
    },
    proxy: {
        type: 'ajax',
        reader: {
            type: 'tree',
            root: 'items'
        }
    }
});