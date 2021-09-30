const signup = require('./modules/signup')
const version = require("@aws-sdk/client-cognito-identity-provider/package.json").version

module.exports.handler = async (event, context) => {
    let statusCode = 500
    try {

        console.log('Event: ', event)
        console.log('Context: ', context)
        console.log('PKG Version: ', version)

        let body = {}
        if (event.body) {
            body = JSON.parse(event.body)
            console.log("Request body ->", body)
            if (!body.username || !body.password) {
                statusCode = 400
                throw new Error("No se especificarion las credenciales del usuario")
            }
        } else {
            statusCode = 400
            throw new Error("No especifico el cuerpo de la petición")
        }
        const userCredentials = {
            username: body.username,
            password: body.password
        }
        let signUpResponse = await signup.cognitoSignUp(userCredentials)
        console.log("signUpResponse ->", signUpResponse)
        return formatResponse(201, {
            "UserConfirmed": signUpResponse.UserConfirmed,
            "CodeDeliveryDetails": signUpResponse.CodeDeliveryDetails,
            "UserSub": signUpResponse.UserSub
        })

    } catch (_err) {

        console.log("ERROR on Handler", _err)
        let err = formatError(statusCode, _err)
        console.log("ERROR FORMAT->", err)
        return err

    }
}

const formatResponse = (statusCode, body) => {
    return {
        "statusCode": statusCode,
        "headers": {
            "Content-Type": "application/json",
        },
        "isBase64Encoded": false,
        "body": JSON.stringify(body)
    }
}

const formatError = (statusCode, error) => {
    return {
        "statusCode": statusCode,
        "headers": {
            "Content-Type": "application/json"
        },
        "isBase64Encoded": false,
        "body": JSON.stringify({ message: error.message })
    }
}