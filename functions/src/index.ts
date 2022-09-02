import * as functions from "firebase-functions";
import * as axios from 'axios';
import * as Buffer from 'buffer';


// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const getImage = functions.https.onRequest((request, response) => {

    console.log("Doing function")

    //allow cross-origin requests
    response.setHeader('Access-Control-Allow-Origin', '*');

    //grab the url from the request
    const url = request.query.url;
    //const url = "https://img.itch.zone/aW1nLzk4NDA3MjkucG5n/315x250%23c/Voix1A.png";

    //make sure the url is a string
    if (typeof url !== 'string') {
        response.status(400).send('url must be a string');
        return;
    }

    console.log("URL: " + url);


    // Get the data from the url
    //make sure images are also available
    axios.default.get(url, { responseType: 'arraybuffer' })
      .then(function (arrayBuffer: axios.AxiosResponse) {
        // handle success
        
        //response.setHeader('Content-Type', res.headers['content-type']);
        let buffer = Buffer.Buffer.from(arrayBuffer.data,'base64');
        response.setHeader('Content-Type', arrayBuffer.headers["content-type"]);
        response.send(buffer);
        //response.render
        //response.end();
        //fs.writeFile(os.tmpdir() + '/image.jpg', res.data, 'binary', function(err) {
        //    if (err) {
        //        console.log(err);
        //        response.status(500).send('Error writing file');
        //        return;
        //    }
        //    console.log("File written");
        //    console.log("os.tmpdir(): " + os.tmpdir());
        //    response.sendFile(os.tmpdir() + '/image.jpg');
        //});
      })
      .catch(function (error: any) {
        // handle error
        console.log("ERROR: " + error);
        response.send("Error!");
      })


  
});




export const getData = functions.https.onRequest((request, response) => {

  console.log("Doing function")

  //allow cross-origin requests
  response.setHeader('Access-Control-Allow-Origin', '*');

  //grab the url from the request
  const url = request.query.url;

  //make sure the url is a string
  if (typeof url !== 'string') {
      response.status(400).send('url must be a string');
      return;
  }

  console.log("URL: " + url);

  // Make a request for a user with a given ID
  axios.default.get(url)
    .then(function (res: any) {
      // handle success
      response.send(res.data);
    })
    .catch(function (error: any) {
      // handle error
      console.log("ERROR: " + error);
      response.send("Error!");
    })



});
