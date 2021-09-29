package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	lambda.Start(HelloWorldHandler)
}

func HelloWorldHandler(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	resp, err := json.Marshal(req)
	if err != nil {
		return serverError(err)
	}
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusAccepted,
		Body:       string(resp),
	}, nil
}

func serverError(err error) (events.APIGatewayProxyResponse, error) {
	fmt.Println(err.Error())

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusInternalServerError,
		Body:       http.StatusText(http.StatusInternalServerError),
	}, nil
}
