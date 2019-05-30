import {Template} from "meteor/templating";


Template.fundingList.helpers({
    list(){
        return Content.find({contentStatus:"진행중"},{});
    }
});


Template.fundingList.events({

});


Template.fundingList.onCreated(function () {
    this.subscribe("contentList");
});

Template.fundingList.onRendered(function () {

});

Template.fundingList.onDestroyed(function () {

});