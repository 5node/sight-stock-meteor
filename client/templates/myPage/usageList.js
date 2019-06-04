import {Template} from "meteor/templating";


Template.usageList.helpers({
    usageList(){
        let userId = sessionStorage.getItem("userId");
        // let userId = "charles@gmail.com";

        return Usage.find({userId: userId})
    },
    prodFinishAt(timestamp) {
        return moment(timestamp).format("YYYY-MM-DD");
    },
});

Template.usageList.events({

    'click button[name=downloadBtn]'(evt, tmpl) {
        alert("The feature has not been implemented.");
    }
});


Template.usageList.onRendered(function() {

})


Template.usageList.onCreated(function () {
});

Template.usageList.onRendered(function () {

});

Template.usageList.onDestroyed(function () {

});
