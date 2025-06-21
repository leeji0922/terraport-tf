exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));
    
    const response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS'
        },
        body: JSON.stringify({
            message: 'Hello from Terraport Lambda!',
            timestamp: new Date().toISOString(),
            path: event.path,
            method: event.httpMethod,
            queryStringParameters: event.queryStringParameters,
            headers: event.headers
        })
    };
    
    return response;
}; 