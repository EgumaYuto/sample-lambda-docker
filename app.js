exports.lambdaHandler = async (event) => {
    console.log(JSON.stringify(event))
    const path = event.requestContext.http.path
    if (path === '/hello') {
        return helloResp()
    } else if (path === '/request') {
        return requestResp()
    } else if (path.startsWith('/request/')) {
        return requestIdResp()
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

const requestResp = () => {
    const body = "{ \"requestId\": \"uuid-hogehoge\" }";
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
        },
        body: body,
        isBase64Encoded: false,
    };
}

const requestIdResp = () => {
    const body = "{ \"status\": \"in-progress\" }";
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