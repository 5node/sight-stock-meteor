import {Template} from "meteor/templating";
import "/imports/collections";//추가


Template.assetList.helpers({
    list(){
        return Content.find({contentStatus:"완료"},{});
    }
});


Template.assetList.events({

});


Template.assetList.onRendered(function() {

})


Template.assetList.onCreated(function () {
    this.subscribe("contentList");
    $(window).on('scroll', function(e) {
        // ... event processing stuff;
        // say it produces value 'zoomAmount' ...

    });
});

Template.assetList.onRendered(function () {

});

Template.assetList.onDestroyed(function () {

});