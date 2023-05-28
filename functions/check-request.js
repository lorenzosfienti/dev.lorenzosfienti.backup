function handler(event) {
    var access_key="${access_key}"
    var access_secret="${access_secret}"
    var url="${url}"
    var request = event.request;
    var response = event.response;
    if (request.uri=='/'){
        return request
    }
    if (!request.headers.access_key){
        var response = {
            statusCode: 302,
            statusDescription: 'Found',
            headers:
                { "location": { "value": url } }
            }

        return response;
    }
    if (!request.headers.access_secret){
        var response = {
            statusCode: 302,
            statusDescription: 'Found',
            headers:
                { "location": { "value": url } }
            }
        return response;
    }
    
    return request;
}