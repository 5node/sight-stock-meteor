import {Template} from "meteor/templating";
import "/imports/collections";//추가
import '../login/login.js';


Template.topnavbar.helpers({
    access(){
        return true;
    }
});


Template.topnavbar.events({

});


Template.topnavbar.onRendered(function() {

})


Template.topnavbar.onCreated(function () {

});

Template.topnavbar.onRendered(function () {

});

Template.topnavbar.onDestroyed(function () {

});