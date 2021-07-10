exports.lambdaHandler = async (_event) => {
    const body = "OK"
    return {
        statusCode: 200,
        headers: {
            'Content-Length': Buffer.byteLength(body),
            'Content-Type': 'application/json',
        },
        isBase64Encoded: true,
        body: body
    };
};