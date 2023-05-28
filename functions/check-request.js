/**
 * Funzione che controlla che nelle richieste di Cloudfront 
 * sia presente negli headers access_key e access_secret.
 * @param {*} event 
 * @returns 
 */
function handler(event) {
    var access_key="${access_key}"
    var access_secret="${access_secret}"
    var request = event.request;
    var response_403 = {
        statusCode: 403
    }
    if (request.uri=='/'){
        return request
    }
    if (!request.headers.access_key){
        return response_403;
    }
    if (!request.headers.access_secret){
        return response_403;
    }

    if (request.headers.access_key!=access_key){
        return response_403;
    }

    if (request.headers.access_secret!=access_secret){
        return response_403;
    }
    
    return request;
}