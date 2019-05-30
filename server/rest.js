import { Meteor } from 'meteor/meteor'
import fs from 'fs';

const TEMP_FILE_PATH = '/Users/charles/Project/temp/';
const IMAGE_FILE_PATH = '/Users/charles/Project/images/';

WebApp.connectHandlers.use("/temp", (req, res, next)=>{

    var filename = req.originalUrl.split("/")[2];
    filename = TEMP_FILE_PATH + filename;

    var fsReadFile = Meteor.wrapAsync(fs.readFile);
    var img = fsReadFile(filename);

    res.writeHead(200);
    res.end(img, 'binary');

});

WebApp.connectHandlers.use("/images", (req, res, next)=>{

    var filename = IMAGE_FILE_PATH + req.originalUrl.split("/")[2];
    var img = Meteor.wrapAsync(fs.readFile)(filename);

    res.writeHead(200);
    res.end(img, 'binary');

});

