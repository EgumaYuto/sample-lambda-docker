exports.lambdaHandler = async (event) => {
    console.log(JSON.stringify(event))
    const path = event.requestContext.http.path
    if (path === '/hello') {
        return helloResp()
    } else {
        return notFoundResp()
    }
};

const helloResp = () => {
    const body = "{ \"message\": \"Hello from Lambda!\" }";
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
        },
        body: body,
        isBase64Encoded: false,
    };
}

const notFoundResp = () => {
    const body = "{ \"message\": \"Not Found\" }";
    return {
        statusCode: 404,
        headers: {
            'Content-Type': 'application/json',
        },
        body: body,
        isBase64Encoded: false,
    };
}