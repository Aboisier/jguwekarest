package io.swagger.api.dataset;


import com.google.gson.internal.LinkedTreeMap;
import io.swagger.annotations.*;
import io.swagger.api.ApiException;
import io.swagger.api.dao.MongoDao;

import javax.ws.rs.*;
import javax.ws.rs.core.Response;

@Path("/")
@Api(description = "Model API")

public class Model {

    @GET
    @Path("/model")
    @Consumes({ "multipart/form-data" })
    @Produces({ "text/uri-list" })
    @ApiOperation(
            value = "List all Models",
            notes = "List all Models.",
            tags={ "model", },
            response = void.class)
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "OK", response = void.class),
            @ApiResponse(code = 400, message = "Bad Request", response = void.class),
            @ApiResponse(code = 401, message = "Unauthorized", response = void.class),
            @ApiResponse(code = 403, message = "Forbidden", response = void.class),
            @ApiResponse(code = 404, message = "Resource Not Found", response = void.class) })
    public Response getModelList(
            @ApiParam(value = "Authorization token" )@HeaderParam("subjectid") String subjectid) throws ApiException {

        MongoDao modelDao = new MongoDao();
        String model_list = modelDao.getModelList();
        modelDao.close();
        return Response
                .ok(model_list)
                .status(Response.Status.OK)
                .build();
    }


    public LinkedTreeMap meta;
    public String datasetURI;
    public Dataset dataset;

    public String model;
    public String validation;

}
