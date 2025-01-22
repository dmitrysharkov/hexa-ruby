## General Principles

* It has to be only one way to define something 
* Automatic documentation generation 
* Strict typing 
* Fail Fast 
* TDD/Test first development 
* Pure functions only (reference transparency principle)

## Algebraic Data Types  

* [x] Validators for primitive types
* [x] Validators for arrays 
* [x] Validators for records
* [x] Pass Options To validators 
* [x] Arrays(Lists) 
* When added undefined to array then skip (?)
* Groups
* [x] Inheritance 
* Defaults for undefined 
* Better error messages for type mismatch 
* [x] Coercing
* Coercing for records 
* Serialization for records
* Pass Options to Coercing 
* [x] Parse Primitives from String
* [x] Equality (check also == vs eql? vs ===)
* Custom options in attributes 
* Enum
* Const Values (like eql constraint?) 
* Unfolded attributes (prefix, postfix)
* [x] Arrays(Lists) inheritance
* Constructor (or factory) (Proc)
* Context -> current errors
* Test/Fix errors collection 
* Add GDPR/Private info 
* Add Access Rights {allow_if, allow_unless}
* Validate Methods? 
* Documentation Generation
* [x] Annotation Style 
* [x] [] operation to add inherit and add validators
* [x] Arrays with prefix items (see JSON Schema) 
* Records with dynamic attributes (see JSON Schema)
* Arrays - behavior with inheritance and redefinition of items?
* Attr Annotation - raise exception if attr_reader not defined?
* Attr Annotation - behavior with inheritance and redefinition?
* Attr Annotation - multiple annotations in one function
* Rename Values to Adt (Algebraic data types)
* Constants 
* Any type 
* Inherit list from same root, make it enumerable and implement ==, eql, etc
* Inherit all from one root (like Type or Value)
* Replace Record Mixin with Record Type (command, event, etc. will be inherited from Record)
* Rename Everything like Ruby native types (Object, Array, Integer, Float, ...)
* In annotations/Unions check that operands are expected types (not native types)
* Pretty Print 

### Serialization
* From Rails Params
* From JSON
* [x] TO JOSN
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

## Pipes 

* receive dependencies in constructors 
* declares input and output _payload_ type 
* if binding output defers form its input then it has to declared it (out: ....) 
* last binging output has to match pipe output 
* Binding functions might be tested outside the pipe just like normal methods(!!!)

### Monads
* __Success(result)__ - (Maybe - Typed success)
* __Failure(error)__ - (Maybe - Typed failure)
* __Skip:__ (For filters, Buffers)
* __Promise:__ Async execution. This can be used to construct SAGAs (!!!)
* __Wait:__ Special type of a Promise when we are waiting for an event 

### Bindings DSL   
* map
* bind
* tee
* connect - use another pipe 
* ...

### Bindings 
* __Binder__: Expects a function to return a monad 
* __Mapper__: Converts function _output_ to Success(output)
* __Pair To Monad:__ converts [result, nil] => Success(result) and [nil, Error] => Failure(error)
* __Monad To Pair:__ converts Success(result) => [result, nil] and Failure(error) => [nil, error]  
* __Filter:__ returns Skip is the filter predicate is false 
* __Buffer:__ returns Skip until the buffer is full 
* __Flip:__ Converts Falure(error) => Success(Error) to results and Success(result) => Skip().
            This can be useful to show errors list while parsing a file for instance. 
* __Connector__: Connects another pipe. (Factory method will be provided to bypass dependencies)


### Pipes 
* Sequence => Output type matches the last step output type 
* AllOf => Output is a fixed length array (tuple)
* OneOf => Output is Union
* AnyOf => Output is a tuple where some places can be skipped (Undefined)
* NoneOf (?)

* QUESTION: how to treat Failure/Skip monads? (Propagate failure? Propagate Skip?)
* QUESTION: How to manage buffer in parallel? (Especially All Of)
* NOTE: transformation from Array(List / Tuple) is a just a mapper  

### Async Execution 
* Every step is atomic 
* State: current __payload__ + Next Step Number 
* State can be saved/restored 
* This is another way to implement workflows (but much more clean and using a general approach) (!!!) 
* QUESTION: is it really necessarily to parallelize AllOf, OneOf, AnyOf in the case of Promise returned
  or just execute then consequently, which makes things much easer? It might me several 2 options             

### Input Streams 
  - CSV Input 
  - CSV Output
  - JSON Input 
  - JSON Output 
  - YAML Input
  - YAML Output 
  - ... and so on 

### Assertion

* asser pipeline => all methods are correct
    
### Examples
```ruby

class MyPipe < Hexa::Pipes::Sequence
  payload String 
  
  bind :hello
  map :bye 

  def hello(payload)
    Success.new("Hello, #{payload}")
  end
  
  def bye(payload)
    "Bye #{payload}"
  end
end

```



## Persistence 
### Entities 
* inherited from a record 
* ids
* has_one
* has_many

* GDPR/Private Info

### Repositories
* SQL Repositories for Entities
* SQL Schema Generation For Entities
* Lazy collections in entities
* Change Sets


### Event Stores 
* SQL Event Store
* Kafka Event Store

### Projections
* TBD
       
## Domain/CQRS

### Messages
* UUID 
* Timestamps
  - Created At
  - Received At
  - Start Processing At
  - End Processing At 
* Sender 
  - IP 
  - UUID 
  - Email?
  - login_name?
  - JWT?
* Some other debug info (?)

### Commands 
* Inherit From Message
* Command Options(Rules) (including validators)
* Command Decider Types
* Command Handlers/Pipelines
* Command Tools (Dependencies) are Handlers Parameters and will be passed to constructor  
* Documentation Generation 

### Queries 
* Inherit From Message
* Params 
* Response 
* Documentation Generation

### Sagas/Orchestration/Choreography
* Can be implemented as Pipes with Promises (!!!)

### Examples 
```ruby

class CreateCaseFileDecider < Hexa::Domain::Decider
  attr_reader :command, :fees_table 
  
  attr_annotate :command, CreateCaseFile
end

class CreateFaceFileHandler < Hexa::Domain::CommandHandler
  input CreateCaseFileDecider
  
  decide :main_claim_was_created 
  decide :side_claims_was_created
  decide :creditor_payment_was_created 
  decide :creditor_bounce_was_created

  def main_claim_created(command:, events:)
    return unless command.params.attribute_defined? :main_claim

    events << MainClaimWasCreated.new(main_claim: command.params.main_claim)
  end

  def side_claims_was_created(command:, events:)
    return unless command.params.attribute_defined? :side_claims

    command.params.side_claims.each do |sc|
      events << SideClaimWasCreated.new(side_claim: sc)
    end
  end
  
  def creditor_payment_was_created(command:, events:)
    # ....
  end
  
  def creditor_bounce_was_created(command:, events:)
    # ...
  end
end

class CreateCollectionFeeDecider < Hexa::Domain::Decider
  attr_reader :command, :case_file, :fees_table
  
  # command is always a first parameter
  attr_annotate :command, CreateCollectionFee
  
  # write models required to execute the command. each write model is an entity 
  attr_annotate :case_file, CaseFile 
  attr_annotate :fees_table, FeesTable
end

class CreateCollectionFeeHandler < Hexa::Domain::CommandHandler
  input CreateCaseFileDecider
  
  decide :collection_fee_was_created 
  
  def collection_fee_was_created(command:, fees_table:, events:)
    command.params
  end
end
```


## Access Control
* ReBAC?
* RBAC?
* ABAC?

## Application 

### Application Services/Use Cases (Command + Query)
* Service Pipelines 
* Documentation Generation 
 
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








