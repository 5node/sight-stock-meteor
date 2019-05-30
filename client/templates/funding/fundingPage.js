import {Template} from "meteor/templating";


Template.funding.helpers({
    title() {
        return "펀딩"
    }
});

Template.funding.events({
    "click .breadcrumb-item" : function(e) {
        e.stopPropagation();
        $('.breadcrumb-item').removeClass('active');
         $(e.target).addClass('active');
    }
});

Template.funding.onRendered(function() {

})


Template.funding.onCreated(function () {

});

Template.funding.onDestroyed(function () {

});