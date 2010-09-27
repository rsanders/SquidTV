// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function mark_episode_read(epid) {
    jQuery.ajax({url: '/episodes/' + epid, method: 'post', data: {seen_at: new Date()}
    });
}
