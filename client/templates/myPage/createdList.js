import {Template} from "meteor/templating";


Template.createdList.helpers({
    createdList(){
        let creatorId = sessionStorage.getItem("userId");
        // let creatorId = "charles@gmail.com";

        console.log(creatorId);

        return Content.find({"contentCreator.userId": creatorId},{});
    },
});

Template.createdListTmpl.helpers({
    fundingFinishAt(timestamp) {
        return moment(timestamp).format("YYYY-MM-DD");
    },
    prodFinishAt(timestamp) {
        return moment(timestamp).format("YYYY-MM-DD");
    },
    checkStatus(contentStatus) {
        return contentStatus == "진행중"
    }
})

Template.createdList.events({
    'click button[name=c-modal]' (evt,tmpl){

        console.log("modal id check - ", this._id);
        sessionStorage.setItem("editItem",this._id);
	},
	'click button[name=resourceUpBtn]' (evt,tmpl){
		sessionStorage.setItem("uploadItem", this._id)
	}
});


Template.createdList.onRendered(function() {

})


Template.createdList.onCreated(function () {
    this.subscribe("contentList");
});

Template.createdList.onRendered(function () {

});

Template.createdList.onDestroyed(function () {

});
