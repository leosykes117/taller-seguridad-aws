const { CognitoIdentityProviderClient, SignUpCommand } = require("@aws-sdk/client-cognito-identity-provider");

module.exports = {
    async cognitoSignUp({username, password}) {
        const client = new CognitoIdentityProviderClient();
        const signUpCommandInput = {
            ClientId: process.env.COGNITO_CLIENT_ID,
            Username: username,
            Password: password
        }
        console.log("signUpCommandInput", signUpCommandInput)
        const command = new SignUpCommand(signUpCommandInput);
        return await client.send(command);
    }
}
