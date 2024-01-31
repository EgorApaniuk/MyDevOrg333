public with sharing class TaskUrlRefreshBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    private static final String API_URL = 'https://pokeapi.co/api/v2/pokemon/';

    private Integer transactionCount = 0;
    private Integer processedTasksCount = 0;
    //! можно инициализиаровать в начале и пользоваться Statefull значениями
    //! String apiResponse = fetchDataFromApi(API_URL);

    public TaskUrlRefreshBatch() {

    }

    public TaskUrlRefreshBatch(String anyVariable) {
        // this.anyVariable = anyVariable;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, testURL__c, Pokemon__c FROM Task WHERE Pokemon__c != NULL AND testURL__c = NULL';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Task> tasks) {
        List<Task> tasksToUpdate = new List<Task>();

        for (Task task : tasks) {
            String apiResponse = fetchDataFromApi(API_URL);

            if (apiResponse != null) {
                String pokemonUrl = getUrlFromRequest(apiResponse, task.Pokemon__c);
                task.testURL__c = pokemonUrl;
                tasksToUpdate.add(task);
                processedTasksCount++;
            }
        }

        if (!tasksToUpdate.isEmpty()) {
            update tasksToUpdate;
        }
        transactionCount++;
    }

    public void finish(Database.BatchableContext BC) {
    }

    private String fetchDataFromApi(String apiUrl) {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            return null;
        }
    }

    /**
     * description  123
     * @author      Egor Apaniuk
     * 
     */
    private String getUrlFromRequest(Object requestResult, String pokemonName) { // можно балкифицировать до возврата мапки

        Map<String, Object> parsedData = (Map<String, Object>)JSON.deserializeUntyped((String)requestResult);
        List<Object> results = (List<Object>)parsedData.get('results');

        String pokemonUrl = null;
        for (Object result : results) {
            Map<String, Object> pokemonData = (Map<String, Object>)result;
            String name = String.valueOf(pokemonData.get('name'));
            if (pokemonName.equalsIgnoreCase(name)) {
                pokemonUrl = String.valueOf(pokemonData.get('url'));
                break;
            }
        }

        return pokemonUrl;
    }

}

// CountContactsOnAccountBatch