import {Template} from "meteor/templating";
import config from "../../../contracts/config.json"; 
import BasicInvestModuleABI from "../../../contracts/ABI/BasicInvestModuleABI.json";
import {ethers} from "ethers";
// import memont from "moment";


Template.fundDetail.helpers({
    content() {
        return Content.findOne({_id: Session.get("CurrentContentId")},{});
    },
    fundPercent() {
        let content = Content.findOne({_id: Session.get("CurrentContentId")},{});
        let percent = Math.floor(content.investedStock / content.contentTotalSupply * 100)

        return isNaN(percent) ? 0 : percent;
    },
    topThreeContentList() {
        let id = Session.get("CurrentContentId");
        let creatorId = Content.findOne({_id: id},{}).contentCreator.userId;

        return Content.find({"contentCreator.userId": creatorId, contentStatus:"완료"},{limit:3});
    },

});

Template.topThreeTmpl.helpers({
    dateSet(timestamp) {
        return moment(timestamp).fromNow();
    }
})

//invest-btn
//해당 투자 모듈에 투자해야한다.
Template.fundDetail.events({
    "click button[name=investBtn]": async(evt,tmpl)=>{

        let klayVal = parseInt(tmpl.find('input[name=investVal]').value);
        let stockVal = parseInt(tmpl.find('input[name=stockVal]').value);
        let content = Content.findOne({_id: Session.get("CurrentContentId")},{});

        if (klayVal == "" || klayVal == 0) {
            alert("Please enter KLAY to invest.");
            return;
        }

        if (content.contentTotalSupply <
            content.investedStock + stockVal) {

            alert("You can't invest any more.");
            return;
        }

        let provider = new ethers.providers.JsonRpcProvider('https://api.baobab.klaytn.net:8651');
		let gasPrice = await provider.getGasPrice();
		let InvestModule = new ethers.Contract(config.BasicInvestModule, BasicInvestModuleABI, provider);
		let userPk = sessionStorage.getItem("pk");
		let wallet = new ethers.Wallet(userPk, provider);
		let contractWithSigner = InvestModule.connect(wallet);
		let value = ethers.utils.parseEther('1.0');
        
        let data = {
			gasLimit : 500000,
			gasPrice : gasPrice,
			value : value
        }
        
		let result = await contractWithSigner.investProduct(wallet.address, data);
		
		console.log(result);
        
        if(result.nonce){
            let param = {
                contentId: content._id,
                investorId: sessionStorage.getItem("userId"),
                investorWalletAddr: sessionStorage.getItem("userId"),
                contentName: content.contentName,
                parValue: content.contentParValue,
                shareNum: stockVal,
                klayVal: klayVal,
                score: 0,
            }

            Meteor.call('investToContent', param ,(err,data)=>{
                if(err){
                    console.log(err);
                    alert('SERVER ERROR => ' + err.error);
                }else{
                    if (data > 0) {
                        alert("you invested!!");
                    }
                }
            });
        }
        
    },
    "keyup input[name=stockVal]" (evt,tmpl) {
        let content = Content.findOne({_id: Session.get("CurrentContentId")},{});

        if (evt.currentTarget.value < 0) {
            alert("You have to apply for at least one share.");
            return;
        }

        $('input[name="investVal"]').val(evt.currentTarget.value * content.contentParValue);
    }
});


Template.fundDetail.onCreated(function () {

    let instance = this;
    instance.subscribe("ContentById");
});

Template.fundDetail.onRendered(function() {

})

Template.fundDetail.onDestroyed(function () {

});