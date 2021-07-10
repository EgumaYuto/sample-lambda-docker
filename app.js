const { WebClient, LogLevel } = require("@slack/web-api");
const AWS = require('aws-sdk');

const client = new WebClient('token', {
    logLevel: LogLevel.DEBUG
})

exports.lambdaHandler = async (event) => {
    const path = event.requestContext.http.path
    if (path === '/hello') {
        return helloResp()
    } else if (path === '/request') {
        return await requestResp()
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

const requestResp = async () => {
    const token = await new AWS.SSM().getParameter({
        Name: process.env['SLACK_TOKEN_SSM_NAME'],
        WithDecryption: true
    }).promise().then(param => param.Parameter.Value);
    await client.chat.postMessage({
        token: token,
        channel: 'C0135D5Q5NH',
        text: 'Approve お願いします'
    })
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