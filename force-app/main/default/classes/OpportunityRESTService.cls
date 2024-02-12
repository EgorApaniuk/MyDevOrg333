@RestResource(urlMapping='/OpportunityREST/*')
global without sharing class OpportunityRESTService {
    //endpoint : /services/apexrest/OpportunityREST/createOpportunity
    // {
    //     "name": "TEST TEST OPP"
    // }

    @HttpPost
    global static void createOpportunity() {
        String quoteJSON = RestContext.request.requestBody.toString();
        OpportunityRequest opportunityReq = (OpportunityRequest)JSON.deserialize(quoteJSON, OpportunityRequest.class);
        RestResponse res = RestContext.response;
        res.statusCode = 400;
        Id result = createNewOpportunity(opportunityReq);
        
        if (String.isBlank(result)) {
            res.responseBody = Blob.valueOf('{\n\"status:\" \"' + 'error creating new opp' + '\"\n}');
        } else {
            OpportunityResponse opportunityRes = new OpportunityResponse(result);
            res.responseBody = Blob.valueOf(JSON.serializePretty(opportunityRes));
            res.statusCode = 200;
        }
    }

    private static Id createNewOpportunity(OpportunityRequest opportunityReq) {
        Opportunity oppToInsert = new Opportunity();
        oppToInsert.CloseDate = Date.today().addDays(30);
        oppToInsert.StageName = 'Prospecting';
        oppToInsert.Name = opportunityReq.name;

        Database.insert(oppToInsert, false);
        return oppToInsert.Id != null ? oppToInsert.Id : null;
    }

    public class OpportunityRequest {
        public String name;
    }

    global class OpportunityResponse {
        public String Id;
        
        public OpportunityResponse(String Id) {
            this.Id = Id;
        }
    }
}