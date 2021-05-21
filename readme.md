# AmplifyTenantCreation
AmplifyTenantCreation populates database with a new schema and a user.
### Usage
Create `config.json` with following content:
```json
{
  "DB": {
    "PostgresConnString": "Conn string with admin access",
    "PostgresCert64": "Base64 Certificate"
  },
  "ScriptTemplate": {
    "TenantID": "schema name",
    "DBAdmin": "DB Role that will be set as the owner of the new schema",
    "DBUser": "DB Role that will have usage rights for the new schema"
  }
}
```
### Creating Providers
In order to create providers follow these steps:
1. Create NLC Instance in IBM Cloud
2. Create NLC Instance record in DB via API
3. Create Classifier record in DB with a random classifierID
4. Create Classifier training request, accept it after training
5. Now you have a valid classifier record, and you can create Provider and Classifier Class records using API
