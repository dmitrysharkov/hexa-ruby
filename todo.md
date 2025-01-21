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
* Test/Fix errors collection 
* Add GDPR/Private info 
* Add Access Rights {allow_if, allow_unless}
* Validate Methods? 
* Documentation Generation
* ~~Writing Stream~~ 
* ~~Annotation Style~~ 
* ~~[] operation to add inherit and add validators~~
* ~~Arrays with prefix items (see JSON Schema)~~ 
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
* Cortege as a mix of Array and Record  
* Tuple as Array with fixed items only 
* Pretty Print 

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
  - JSON Input 
  - JSON Output 
  - YAML Input
  - YAML Output 
  - ... and so on 

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

### Projections


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
* Command Tools are Handlers Parameters
* Documentation Generation 

### Tools
* Intialization/Bootstapping
* Live Reload (?)
  * for instance we have received a message that fee table was updted 
  * then fee table has to be reloaded 
  * or entire service has to be reloaded (stop the world event)

### Queries 
* Inherit From Message
* Params 
* Response 
* Documentation Generation

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

### Access Control 
* ReBAC
* RBAC
* ABAC

```ruby

CreateFeeDecider = Record[command: CreateFee, model: Model, events: List[Event1|Event2|Event3]]

# CreateFeeHandler = CommnadHandler[CreateFeeDecider]
#
# handler = CreateFeeHandler.new do |command, tools:, events:|
#   events << Event
# end

class CassFileAggregate 
  decide CreateFeeDecider, CommandHandler.new(fee_table: FeeTable.new)
  decice CreateFeeDecider, CreateFee.new()
  decide CreateFeeDecider, CreateFeeNext.new 
  
  evolve 
end

class CreateFaceFileHandler < Hexa::Pipe
  input CreateFeeDecider
  
  map :main_claim_created
  map :create_side_claims
  map :creaat_payments
  map :create_bounces 
  
  def main_claim_created(command:, **)
    # events << NewUserEvent.new(bla,bla,bla)
    CreateFeeDecider.new(command, model, tools, events + [MainClaimWasCreated.new(command.params.main_claim)])
  end
  
  def create_side_claims
    
  end
end

class CreateCasseFileToos < Hexa::Record 
  attr_reader :fee_table 
  
  attr_annotate :fee_table, FeeTable 
end

# Decider Pipe is a Short Cut
class CreateFaceFileHandler < Hexa::DeciderPipe
  tools CreateCaseFileTools
  
  input CreateFeeDecider

  event_map :main_claim_created
  event_map :create_side_claims
  event_map :creaat_payments
  event_map :create_bounces

  def main_claim_created(command:, **)
    # events << NewUserEvent.new(bla,bla,bla)
    return unless command.params.attribute_defined? :main_claim
     
    event MainClaimWasCreated, command.params.main_claim
  end

  def create_side_claims

  end
  

end

# another short cut example 


class CreateFaceFileHandler < Hexa::DeciderPipe[CreateFeeDecider, CreateCaseFileTools]
  event_map MainClaimWasCreated
  event_map List[SideClaimWasCreated]
  event_map List[CreditorPaymentWasCreated]
  event_map List[CreditorPaymentBounceCreated]

  def main_claim_created(command:, **)
    # events << NewUserEvent.new(bla,bla,bla)
    return unless command.params.attribute_defined? :main_claim

    event command.params.main_claim
  end

  def side_claims_was_created(command:, **)
    return unless command.params.attribute_defined? :side_claims
    
    events command.side_claims
  end


end



```

## Testing 

* asser pipeline => all methods are correct





