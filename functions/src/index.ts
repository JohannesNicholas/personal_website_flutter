import * as functions from "firebase-functions";
import * as axios from 'axios';


// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const getData = functions.https.onRequest((request, response) => {

    console.log("Doing function")

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
