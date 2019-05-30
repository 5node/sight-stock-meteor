import {Meteor} from "meteor/meteor";
import fs from 'fs';

const TEMP_FILE_PATH = '/Users/charles/Project/temp/';
const IMAGE_FILE_PATH = '/Users/charles/Project/images/';

Meteor.methods({
    getContentById(content_id){
        if(!content_id){
            throw new Meteor.Error("입력값이 없습니다");
        }

        return Content.findOne({_id: content_id});
    },
    insertContentProposal(proposal) {
        if (!proposal) {
            throw new Meteor.Error("업로드할 데이터가 없습니다.");
        }
        if(!proposal.image ){
            throw new Meteor.Error("업로드할 이미지가 없습니다.");
        }

        //#1 경로 변수
        var tempDir = TEMP_FILE_PATH ;
        var imageDir = IMAGE_FILE_PATH ;

        //#2 파일 읽기
        var resource = Meteor.wrapAsync(fs.readFile)(tempDir+proposal.image);

        //#3 파일 쓰기
        Meteor.wrapAsync(fs.writeFile)(imageDir + proposal.image, resource);

        //#4 임시폴더 파일 삭제
        Meteor.wrapAsync(fs.unlink)(tempDir + proposal.image);

        //#4 url 셋팅 하기
        proposal.contentThumbnail = "/images/"+proposal.image;


        proposal.investedStock = 0;
        proposal.investedKlay = 0;
        proposal.contentInvestorCnt = 0;
        proposal.purchaceModuleAddr = "";
        proposal.investModuleAddr = "";
        proposal.distributeModuleAddr = "";
        proposal.FundingFinishDay = new Date('Dec 30, 2019');

        return Content.insert(proposal)
    },
    saveFile(image = {resource:"",name:"",encoding:""}){

        // #1  경로변수 설정 , 랜덤 id 생성
        var path = TEMP_FILE_PATH;
        var fileName = Random.id();

        // #2  writeFile 함수를 sync 함수로 만들기
        var fsWriteFile = Meteor.wrapAsync(fs.writeFile);

        // #3 저장하기
        fsWriteFile(path + fileName, image.resource, image.encoding);

        return {fileName:fileName,name:image.name};  // #4 결과값 리턴

    },

    insertContentResource(proposal) {
        if (!proposal) {
            throw new Meteor.Error("업로드할 데이터가 없습니다.");
        }
        if(proposal.subImageList.length == 0 ){
            throw new Meteor.Error("업로드할 이미지가 없습니다.");
        }

        //#1 경로 변수
        var tempDir = TEMP_FILE_PATH ;
        var imageDir = IMAGE_FILE_PATH ;
        let contentResourceList = [];

        for (let i=0; i<proposal.subImageList.length; i++) {
            var image = proposal.subImageList[i];
            //#2 파일 읽기
            var resource = Meteor.wrapAsync(fs.readFile)(tempDir+ image);

            //#3 파일 쓰기
            Meteor.wrapAsync(fs.writeFile)(imageDir + image, resource);

            //#4 임시폴더 파일 삭제
            Meteor.wrapAsync(fs.unlink)(tempDir + image);

            contentResourceList.push({url: "/images/"+image});
        }

        let set = {
            contentStatus: "완료",
            contentScore: 0,
            contentResourceList: contentResourceList,
            ProdFinishDay: new Date(),
        }


        return Content.update({_id: proposal.contentId}, {$set:set});

    },

});

