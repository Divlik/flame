/*
 * Fledge REST API
 *
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * API version: 1.0.0
 * Generated by: OpenAPI Generator (https://openapi-generator.tech)
 */

package openapi

import (
	"context"
	"net/http"
	"errors"
)

// DesignApiService is a service that implents the logic for the DesignApiServicer
// This service should implement the business logic for every endpoint for the DesignApi API. 
// Include any external packages or services that will be required by this service.
type DesignApiService struct {
}

// NewDesignApiService creates a default api service
func NewDesignApiService() DesignApiServicer {
	return &DesignApiService{}
}

// CreateDesign - Create a new design template.
func (s *DesignApiService) CreateDesign(ctx context.Context, user string, designInfo DesignInfo) (ImplResponse, error) {
	// TODO - update CreateDesign with the required logic for this service method.
	// Add api_design_service.go to the .openapi-generator-ignore to avoid overwriting this service implementation when updating open api generation.

	//TODO: Uncomment the next line to return response Response(201, {}) or use other options such as http.Ok ...
	//return Response(201, nil),nil

	//TODO: Uncomment the next line to return response Response(0, Error{}) or use other options such as http.Ok ...
	//return Response(0, Error{}), nil

	return Response(http.StatusNotImplemented, nil), errors.New("CreateDesign method not implemented")
}

// GetDesign - Get design template information
func (s *DesignApiService) GetDesign(ctx context.Context, user string, designId string) (ImplResponse, error) {
	// TODO - update GetDesign with the required logic for this service method.
	// Add api_design_service.go to the .openapi-generator-ignore to avoid overwriting this service implementation when updating open api generation.

	//TODO: Uncomment the next line to return response Response(200, Design{}) or use other options such as http.Ok ...
	//return Response(200, Design{}), nil

	//TODO: Uncomment the next line to return response Response(0, Error{}) or use other options such as http.Ok ...
	//return Response(0, Error{}), nil

	return Response(http.StatusNotImplemented, nil), errors.New("GetDesign method not implemented")
}
