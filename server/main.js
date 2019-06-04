import { Meteor } from 'meteor/meteor';
import './rest';
import "/imports/collections";//추가
import "./publications/Content";//추가
import './methods/Content';
import './methods/Creator';
import './methods/Invest';
import './methods/Usage';


// sight-stock-meteor > meteor npm install faker
import faker from 'faker';
faker.locale = "en";

Meteor.startup(() => {
  // code to run on server at startup

    if(Content.find().count()==0) {

        let contentResourceUrlArr = [
            {url:"https://images.pexels.com/photos/462162/pexels-photo-462162.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/206448/pexels-photo-206448.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1386604/pexels-photo-1386604.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/870711/pexels-photo-870711.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/45853/grey-crowned-crane-bird-crane-animal-45853.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1545590/pexels-photo-1545590.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/449627/pexels-photo-449627.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/5390/sunset-hands-love-woman.jpg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/234510/pexels-photo-234510.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/268533/pexels-photo-268533.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/414102/pexels-photo-414102.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/273136/pexels-photo-273136.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1181181/pexels-photo-1181181.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/40192/woman-happiness-sunrise-silhouette-40192.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1237119/pexels-photo-1237119.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1937394/pexels-photo-1937394.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/53184/peacock-bird-plumage-color-53184.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1089855/pexels-photo-1089855.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/235734/pexels-photo-235734.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/931007/pexels-photo-931007.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/258112/pexels-photo-258112.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1647214/pexels-photo-1647214.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1047051/pexels-photo-1047051.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
            ,{url:"https://images.pexels.com/photos/1076429/pexels-photo-1076429.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"}
        ];

        let fundThumbnail = [
            "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/782f8331-cab4-46fc-aadc-6c778df213dc/d9vif0i-2d16bbb8-c691-4d5c-a6c9-da76e008afb9.jpg/v1/fill/w_370,h_250,q_70,strp/s_basavaraj_ireland___pure_relaxation_beautiful_by_sbasavarajireland_d9vif0i-250t.jpg",
            "http://raagaholidays.com/img/packages/BeautifulBali.jpg",
            "https://piktoclub.com/wp-content/plugins/download-manager/cache/beautiful-blooming-bright-5815-370x250.jpg",
            "https://yellowstoneclub.com/wp-content/uploads/ewpt_cache/370x250_100_1_c_FFFFFF_552efd5991b4cbc354d35d5b42dd2678_golf-110.jpg",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFCJRSdMMiynQqVnD3CjOuEA3vi33q5YlUgqzLDa0lEydCLHka",
            "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/2e4426f4-edfe-45f3-99c7-c376dd3336bd/d6lx6q0-81afa76d-e6a5-4fcb-b367-6f6ee56deec4.jpg/v1/fill/w_370,h_250,q_70,strp/t01_by_la_child_d6lx6q0-250t.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NDA2IiwicGF0aCI6IlwvZlwvMmU0NDI2ZjQtZWRmZS00NWYzLTk5YzctYzM3NmRkMzMzNmJkXC9kNmx4NnEwLTgxYWZhNzZkLWU2YTUtNGZjYi1iMzY3LTZmNmVlNTZkZWVjNC5qcGciLCJ3aWR0aCI6Ijw9NjAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.UvljTWFNF1gROKjs73epnCa61mA9xkxGvE--eitALZ0",
            "http://1.bp.blogspot.com/-PzVvgQ_1odw/VYUG808deWI/AAAAAAAAAfo/XPR2MnAuDMk/w370-h250-c/beauty-house.jpg",
            "http://escapetoursamana.com/escape-tours-excursions-samana-tour-operator-and-agency-370px.jpg",
            "https://www.northmayo.ie/wp-content/uploads/2016/05/Ceide-Fields-FI-Content-Pool-370x250.jpg",
            "https://www.whatagreenlife.com/wp-content/uploads/2014/11/roof-terrace-design-lawn-boxwood-hedges-wooden-furniture-370x250.jpg",
            "https://www.hotelcasablanca.net.br/media/fotos/370_250/2113.jpg",
            "http://www.dolomitesadventure.com/wp/wp-content/uploads/2014/04/Cima-Scotoni-Enrosadira2-370x250.jpg"
        ]

        for(let i = 0 ; i<12 ; i++){

            let dummyContent = {
                contentStatus:faker.random.arrayElement(['진행중','완료'])
                ,contentThumbnail: fundThumbnail[i]
                ,contentResourceList:shuffle(contentResourceUrlArr)
                ,contentId:""
                ,contentCreator: {
                    userId: "chuck@gmail.com",
                    job: "photographer",
                    desc: "I'm a photographer trying to capture the light.",
                    name: 'Chuck',
                    creatorCareerList: [
                        {career: "World Film Festival Award for Best Independent Film", at: faker.date.between('2019-10-30', '2019-12-25')},
                        {career: "World Photo Festival Gold Award", at: faker.date.between('2019-10-30', '2019-12-25')},
                        {career: "worked 3 years in advertising planning company", at: faker.date.between('2019-10-30', '2019-12-25')},
                        {career: "Copywriter Global Contest Silver Award", at: faker.date.between('2019-10-30', '2019-12-25')}
                    ],
                    creatorThumbnail: "https://mdbootstrap.com/img/Photos/Avatars/img%20(32).jpg",
                    klaytnAddress: "0x4Ab3cC00872F9Ec8142B02f5893834393eA1020B"
                }
                ,contentTag:faker.fake([
					{
						"tag" : "Travel"
					},
					{
						"tag" : "Philippines"
					},
					{
						"tag" : "Deep Ocean"
					}
				])
                ,contentName:faker.random.arrayElement([
                    "Together with lives in blue sea of bohol",
                    "Camera captures daily lives of Kyoto, Japan",
                    "White coluds in the sky",
                    "From cradle to grave, documentary images",
                    "Nature lives with naigirian autochtones",
                    "Marriages around the world recorded",
                    "Feel the beeeatssss of european clubs"
                ])
                ,investedKlay:faker.random.number(1000)
                ,investedStock:faker.random.number(1000)
                ,contentReturn:faker.random.number(10)
                ,contentReplyList:[
                    {name:faker.fake("{{name.lastName}}{{name.firstName}}"),text:faker.lorem.sentence()}
                    ,{name:faker.fake("{{name.lastName}}{{name.firstName}}"),text:faker.lorem.sentence()}
                    ,{name:faker.fake("{{name.lastName}}{{name.firstName}}"),text:faker.lorem.sentence()}
                ]
                ,contentScore:faker.random.number(10)
                ,contentDesc:faker.random.arrayElement([
                    "Incredible scenery under the blue sea of Bohol/\n/\r" +
                    "Travel to capture sea full of lives/<br>/g " +
                    "Will caputre masterpiece outstands to any other photographics",

                    "Daily lives of Kyoto, Japan " +
                    "Kyoto, so near and yet so far city" +
                    "The charming city silent, cozy, and still keeping its own color." +
                    "I will capture daily lives of there.",

                    "White coluds in the sky " +
                    "I will capture images of special moments," +
                    "Like scenery of sky captured upon the sky through special camera" +
                    "And skydivings by experts",

                    "From cradle to grave " +
                    "Set of documentary images about whole life" +
                    "Unchallenged, capturing the start and end of a human's life" +
                    "will be started, as part of bold project.",

                    "Nature lives with naigirian autochtones " +
                    "The experiences of premival can't expreienced through city life will be recorded as image, " +
                    "through 3-months cohabit with autochtones " +
                    "Price of this product contains donation for people of undeveloped countries' necessity.",

                    "Marriages around the world recorded " +
                    "We just know marriage for ROK" +
                    "But in the world, many ways of marriage exsist, on their own way.",

                    "Feel the beeeatssss of european clubs " +
                    "What will happen in european clubs? " +
                    "Colorful moments of late-night lives, will be captured in images."
                ])
                ,contentProdCost:faker.random.number({min:100,max:300,precision:1})
                ,contentUsingCost:faker.random.number({min:1,max:10,precision:1})
                ,contentTotalSupply:faker.random.number({min:1000,max:3000,precision:1000})
                ,contentParValue:faker.random.number({min:1,max:10,precision:1})
                ,contentFundingFinishDay:faker.date.between('2019-08-01','2019-10-01')
                ,FundingFinishDay:faker.date.between('2019-10-30','2019-12-25')
                ,ProdFinishDay:faker.date.between('2020-01-01','2020-01-31')
                ,contentInvestorCnt:faker.random.number({min:1,max:40})
                ,contentTags: faker.random.arrayElement([["Beach","the bottom of water"],["sky","green","overseas"],["Characteristic","Character","Scenery"]])
                ,purchaceModuleAddr: ""
                ,investModuleAddr: ""
                ,distributeModuleAddr: ""
            };
            Content.insert(dummyContent);
        }

    }

    if(Meteor.users.find().count()==0) {

        let email = "chuck@gmail.com";
        let password = "0xefbe469ae09b15bbe22823d66200d93771632e7914584bd0f067697cf02eaeae";

        let job = "photographer",
            desc = faker.random.arrayElement(["I'm a photographer trying to capture the light.","It creates the only work."]),
            name = "Chuck",
            creatorCareerList = [
                {career: "World Film Festival Award for Best Independent Film", at: faker.date.between('2019-10-30', '2019-12-25')},
                        {career: "World Photo Festival Gold Award", at: faker.date.between('2019-10-30', '2019-12-25')},
                        {career: "worked 3 years in advertising planning company", at: faker.date.between('2019-10-30', '2019-12-25')},
                        {career: "Copywriter Global Contest Silver Award", at: faker.date.between('2019-10-30', '2019-12-25')}
                ],
            creatorThumbnail = "https://mdbootstrap.com/img/Photos/Avatars/img%20(32).jpg",
            klaytnAddress = "0x39bf8A6ca150d9858D2BfE67DA37440Fb0d1F02b";

        let userInfo = { email, password, profile : { job, name , desc, creatorCareerList, creatorThumbnail, klaytnAddress} };


        try {
            Accounts.createUser(userInfo,function(error){
                console.log(error);
            });
        } catch (err) {
            console.log(err);
        }

    }

    if(Usage.find().count()==0) {


    }

    if(Invest.find().count()==0) {
		// var test = Content.find({}).fetch()
		// for(var i = 0; i < 12; i++){
		// 	let dummyInvest={
		// 		contentId: test[i]._id,
        //         investorId: faker.random.arrayElement(["charles@gmail.com", "chuck@gmail.com", "joe@gmail.com", "pai@gmail.com"]),
		// 		investorWalletAddr: faker.random.arrayElement(["AAA", "BBB", "CCC", "DDD"]),
		// 		contentName: test[i].contentName,
		// 		parValue: test[i].contentParValue,
        //         klayVal: 20,
		// 		shareNum: faker.random.number(10),
        //         sharePer: 2,
		// 		score: test[i].contentScore
		// 	}
		// 	Invest.insert(dummyInvest)
		// }
    }


});


function shuffle(array) {
    var currentIndex = array.length, temporaryValue, randomIndex;

    // While there remain elements to shuffle...
    while (0 !== currentIndex) {

        // Pick a remaining element...
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;

        // And swap it with the current element.
        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
    }

    return array;
}
