import {Template} from "meteor/templating";


Template.commentList.helpers({
});


Template.commentList.events({
    'click button[name=commentBtn]'(evt, tmpl) {
        alert("The feature has not been implemented.");
    }
});


Template.commentList.onCreated(function () {
});

Template.commentList.onRendered(function () {

});

Template.commentList.onDestroyed(function () {

});