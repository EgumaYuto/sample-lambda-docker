exports.lambdaHandler = async (event) => {
    console.log(JSON.stringify(event))
    const body = "{ \"message\": \"Hello from Lambda!\" }";
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
        },
        body: body,
        isBase64Encoded: false,
    };
};