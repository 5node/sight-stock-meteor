import {Template} from "meteor/templating";
import {Meteor} from "meteor/meteor";
const subFileList = [];


Template.uploadProductionModal.helpers({
    hashTagsCount : [{}]
});


Template.uploadProductionModal.events({

    //썸네일 파일 업로드
    'change input[data-production="thumbnail"]' : (e,t) => {
		var fileReader = new FileReader();
		var fileName = e.currentTarget.files[0].name ;
		var file = e.currentTarget.files[0];

		fileReader.onload = (file) => {
			var image = {
				resource: file.srcElement.result,
				name: file.name,
				encoding: 'binary',
			};

			// 다음은 image 를 서버로 던지기 구현
			Meteor.call('saveFile', image, function (err, result) {
				if (err) {
					alert(err);
				} else {
					$(e.target).next('.custom-file-label').html(result.fileName);
					subFileList.push(result.fileName);

				}
			});
		};
		fileReader.readAsBinaryString(file);
    },
    //서브이미지 여러개 파일 업로드
    'change input[data-production="subImage"]' : (e,t) => {
		var fileReader = new FileReader();
		var fileName = e.currentTarget.files[0].name ;
		var file = e.currentTarget.files[0];


		fileReader.onload = (file) => {
			var image = {
				resource: file.srcElement.result,
				name: file.name,
				encoding: 'binary',
			};

			// 다음은 image 를 서버로 던지기 구현
			Meteor.call('saveFile', image, function (err, result) {
				if (err) {
					alert(err);
				} else {

					subFileList.push(result.fileName);

					for (var i = 0, str = ''; i < subFileList.length; i++) {
						str = str + `<li>${subFileList[i]}</li>`;
					}
					$('.sub-files').html(str);
				}
			});
		};
		fileReader.readAsBinaryString(file);

    },
    'submit form[data-production="form"]': async(e,tmpl) => {
		e.preventDefault();

		let param = {
			contentId: sessionStorage.getItem("uploadItem"),
			subImageList: subFileList
		}

		Meteor.call('insertContentResource', param ,(err,data)=>{
			if(err){
				console.log(err);
				alert('서버에러 => ' + err.error);
			}else{
				alert(data+"개의 업로드를 완료하였습니다.");
			}
		});
		location.reload();
	},

});



Template.uploadProductionModal.onCreated(function () {

});

Template.uploadProductionModal.onRendered(function () {
});

Template.uploadProductionModal.onDestroyed(function () {

});