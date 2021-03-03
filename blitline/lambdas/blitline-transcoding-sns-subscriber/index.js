'use strict';
const http = require('http')
console.log('Loading function');

module.exports.handler = async (event, context) => {

    //sendData(options, data)
    var msg = JSON.parse(event.Records[0].Sns.Message)
    
    const data = JSON.stringify(
        {
            "Message" : {
                "state" : msg.state,
                "userMetadata" : msg.userMetadata,
                "outputs" : msg.outputs
            }
        }
    );
    
    const options = {
      hostname: process.env.BLITLINE_ENDPOINT,
      port: 80,
      path: process.env.PATH,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': data.length
      }
    } 
    console.log('Endpoint Address : ', process.env.BLITLINE_ENDPOINT)
    console.log('Event Data::', data);
    
    return new Promise((resolve, reject) => {

      const req = http.request(options, (res) => {
        console.log('success')
        resolve("success");
      });
      
      req.on('error', (error) => {
        reject(error.message);
      })
      
      req.write(data)
      req.end()
    });
  
};