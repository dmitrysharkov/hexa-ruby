## Principles

* It has to be only one way to define something 
* Automatic documentation generation 


## Parts 

### Values 
* ~~Validators for primitive types~~
* ~~Validators for arrays~~
* ~~Validators for records~~
* ~~Pass Options To validators~~ 
* ~~Arrays~~ 
* When added undefined to array then skip (?)
* Groups
* ~~Inheritance~~ 
* Defaults for undefined 
* Better error messages for type mismatch 
* ~~Coercing~~ 
* ~~Serialization~~
* Coercing for records 
* Serialization for records
* Pass Options to Coercing 
* ~~Parse Primitives from String~~
* ~~Equality~~ (check also == vs eql? vs ===)
* Custom options in attributes 
* Enum
* Const Values (like eql constraint?) 
* Unfolded attributes (prefix, postfix)
* ~~Arrays inheritance~~
* Constructor (or factory) (Proc)
* Context -> current errors 
* Add GDPR/Private info 
* Add Access Rights {allow_if, allow_unless}
* Validate Method 
* Documentation Generation
* ~~Writing Stream~~ 
* Annotation Style 
* ~~[] operation to add inherit and add validators~~
* ~~Arrays with prefix items (see JSON Schema)~~ 
* Records with dynamic attributes (see JSON Schema)
* Arrays - behavior with inheritance and redefinition of items?




## Pipes 

### Monads
* Success - (Maybe - Typed success)
* Failure - (Maybe - Typed failure)
* Skip (For Grouping)
* Wait (?)
* Promise (?)

### Connectors 
* map
* bind
* tee 

### Blocks
* Transform 
* Pair To Monad
* Monad To Pair 
* Select
* Reject
* Group
* Select Errors
* Reject Errors 
* Group Errors 


### Pipes 
* Sequence
* Parallel - All Of (How To Join?)
* Parallel - One Of
* Parallel - Any Of (How To Join?) 
* Parallel - None Of
* Join

* Streams 
  - CSV Input 
  - CSV Output

```ruby

p1 = Hexa::Pipes::Seq.new do
  bind Select do |val|
    
  end
  
  map do 
    
  end
end

```




### Formats 
* From Rails Params
* From JSON 
* ~~TO JOSN~~ 
* To JSON with writing stream 
* To JSON with reading stream 
* From CSV
* TO CSV
* From XML (not now)
* TO XML
* From Excel
* TO Excel 
* To INI
* From INI
* From Yaml
* To Yaml
* From Avro
* To Avro
* From Protobuf
* To Protobuf
* From GraphQL
* To GraphQL

### Schema Generation
* JSON Schema
* GraphQL
* Protobuf
* Avro

### Pipes
* Lazy Loading
* Piping

### Entities 
* ids
* has_one
* has_many
* Lazy collections in entities
* Change Sets
* SQL Repositories for Entities 
* SQL Schema Generation For Entities
* GDPR/Private Info 

### Events 
* SQL Event Store
* Kafka Event Store

### Commands 
* Command Options (including validators)
* Projections 
* Command Pipelines 
* Documentation Generation 

### Queries 
* Params 
* Response 
* Documentation Generation

### Application Services 
 
### Application Adapters  
* OpenAPI / Schemas 
    - server
    - generate server contract  
    - validate server contract
    - client 
    - generate client
* GraphQL
   - server 
   - generate server contract 
   - validate server contract 
   - client 
   - generate client 
* gRPC / Protobuf
   - server
   - generate server contract
   - validate server contract
   - client
   - generate client
* Apache Arvo 
  - server
  - generate server contract
  - validate server contract
  - client
  - generate client
* Web Sockets 
* Cmd
* Console 

### Application Event Buses
* SQS
* Kafka 

### Access Control 
* ReBAC
* RBAC
* ABAC



