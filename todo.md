# Hexagonal Architecture On Ruby 

## General Principles

* It has to be only one way to define something 
* Automatic documentation generation 
* Strict typing 
* Fail Fast 
* TDD/Test first development 
* Pure functions only (reference transparency principle)

## Algebraic Data Types 

### General
* Enum
* Const Values (like eql constraint?) 
* Constructor (or factory) (Proc)
* Documentation Generation
* Any type 
* Inherit all types from one root (like Type or Value)
* Pretty Print

### Types 
* ScalarType 
* MapType 
* RecordType 
* ListType 
* TupleType 
* UndefinedType
* ConstType 
* AnyType 
* EnumType 

### Classes 
* Scalar < ::Object
* Map < ::Hash 
* Record < ::Object
* List < ::Amount 
* Tuple < ::Amount 
* Undefined < ::Object 
* Const < ::Object
* Any < ::Object
* Enum < ::Object
* Choice < ::Object


### Scalars
* [x] Coercing
* Pass Options to Coercing
* [x] Parse Primitives from String
* Improve Naming (for instance: StringValue, IntegerValue, FloatValue, ...)

 
### Records 
* Groups (AllOf, AnyOf, OneOf)
* [x] Inheritance
* Defaults for undefined
* Coercing for records
* [x] Equality (check also == vs eql? vs ===)
* Custom options in attributes
* Unfolded attributes (prefix, postfix)
* [x] Annotation Style
* Records with dynamic attributes (see JSON Schema)
* Attr Annotation - raise exception if attr_reader not defined?
* Attr Annotation - behavior with inheritance and redefinition?
* Attr Annotation - multiple annotations in one function
* Replace Record Mixin with Record Type (command, event, etc. will be inherited from Record)


### Arrays 
* [x] Arrays(Lists)
* When added undefined to array then skip (?)
* [x] Arrays(Lists) inheritance
* [x] Arrays with prefix items (see JSON Schema)
* Arrays - behavior with inheritance and redefinition of items?
* Inherit list from same root, make it enumerable and implement ==, eql, etc
* use sintax shugar ```List[[A,B,C], D]``` istead of ``` List[D, prefix_items: [A,B,C]]```


### Validation 
* [x] Validators for primitive types
* [x] Validators for arrays
* [x] Validators for records
* [x] Pass Options To validators
* Better error messages for type mismatch
* Context -> current errors
* Validate Methods?
* Test/Fix errors collection
* [x] [] operation to add inherit and add validators
* Validator to_proc

### Unions
* In annotations/Unions check that operands are expected types (not native types)

### Privacy & Security 
* Add GDPR/Private info
* Add Access Rights {allow_if, allow_unless}
* QUESTION: Take it to a separate context to not mix with business logic 
 (at least for access control)

### Mapping/Transformations  
* Deconstruct 
* Construct 
* Mapping rule: deconstruct + construct
* For lists mappings we can use specification (see below)

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

## Specifications 
* Implementation of a [Specification Pattern](https://en.wikipedia.org/wiki/Specification_pattern)
* Will be serializable/unserializable 
* QUESTION: is specification is a specific version of a pipeline?
* And 
* Or
* Not
* With: select sub-cluster of data 

## Pipes 


* Read this [blog](https://fsharpforfunandprofit.com/rop/)
* receive dependencies in constructors 
* [x] declares input and output _payload_ type 
* [x] if binding output defers form its input then it has to declared it (out: ....) 
* [x] last binging output has to match pipe output 
* Binding functions might be tested outside the pipe just like normal methods(!!!)
* Type Validations for ADT (including primitives?, Array)
* Bypass Primitives and Array like instances and pass to payload as natives
  (To avoid validations during the loop)
* Replace default input from nil to any?
* Use ADT for type validation. 
* Use ADT for parametrisation.

### Monads
* [x] __Success(result)__ - (Maybe - Typed success)  
* [x] __Failure(error)__ - (Maybe - Typed failure) 
* [x] __Skip:__ (For filters, Buffers)
* __Promise:__ Async execution. This can be used to construct SAGAs (!!!)
* __Wait:__ Special type of a Promise when we are waiting for an event 

### Bindings DSL   
* [x] map
* [x] bind
* [x] tee
* [x] ret
* chunk
* conn - use another pipe 
* add resque from exceptions (at least to flat map)
* allow define steps recursively for one_of, any_of, all_of

### Bindings 
* [x] __Bind__: Expects a function to return a monad 
* [x] __Map__: Converts function _output_ to Success(output)
* [x] __Ret__:  [nil, error] => Failure, [any,nil] => Success(any)
* [x] __Tee__: side effects
* [x] __Filter:__ returns Skip is the filter predicate is false 
* __Keep:__ returns Skip until the buffer is full 
* __Connector__: Connects another pipe. (Factory method will be provided to bypass dependencies)

### Macros 
* Is a subclass of a Pipe which can implement some logic 
* Might have ADT parameters 
* It has to be a macro to execute commands from other application
* If has to be a macro which maps input output (deconstruct => construct)

### Pipelines 
* [x] Sequence => Output type matches the last step output type 
* AllOf => Output is a fixed length array (tuple)
* OneOf => Output is Union
* AnyOf => Output is a tuple where some places can be skipped (Undefined)
* NoneOf (?)

* QUESTION: how to treat Failure/Skip monads? (Propagate failure? Propagate Skip?)
* QUESTION: How to manage buffer in parallel? (Especially All Of)
* NOTE: transformation from Array(List / Tuple) is a just a mapper 

### Loops & Generators 
* __Loop__ will repeat underline pipe several times (while specification is true)
* __Generator__ is an opposite to a buffer. It receives one input and return multiple outputs
  CSV => parser is a Generator. CSV Writer => is a buffer (!!!)

### Async Execution 
* Every step is atomic 
* State: current __payload__ + Next Step Number 
* State can be saved/restored 
* This is another way to implement workflows (but much more clean and using a general approach) (!!!)
* Multithreading: wait_all, wait_one.
* Multithreading state is an entire tree state of all substates.
  Optimistic locking will be applied. Conflict means that 2 threads tried to execute
  the same _promise_. Options: just ignore or suspend the execution and report an error.
* Execution log: same principle and even sourcing (!!!). Event: "Step 124 DONE"
* Prevent endless loops
* Versioning/Migration         

### Serialization 
* It has to be possible to serialize and unserialize pipelines (Json etc)
* It will be possible to build a pipeline in front end, serialize and JSON, 
  then unserialize and execute in the Runtime

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
  input String 
  
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
* ReBAC? (see this [video](https://www.youtube.com/watch?v=nUKBQ06-8xk&t=2043s))
* RBAC?
* ABAC?
* Access Control is a domain
* We can use __specifications__ do define complex access control rules 

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

### Apartment
* __In site__: means the entire application instantiated as an op
* __Co-Host__: means executed on the same server (container) in a parallel process.
  Communication can be done via unix sockets.
* __Remote__: means executed on the another server.


### Application Event Buses
* SQS
* Kafka 

## Communication between applications (Context Mapping)
* See this [video](https://www.youtube.com/watch?v=v4Jt2-Vx2E4&list=PLLMAS43NKQJAnLQwk-ZduvtvYJWgDyKX5&index=4)

      

## Functional Programming 

See this [presentation](https://www.slideshare.net/slideshow/domain-modeling-made-functional-devternity-2022/254826776#32)

```ruby



Suit = Enum['Club', 'Diamond', 'Spade', 'Heart']
Rank = Enum[*%w[Two Three Four Five Six Seven Eight Nine Ten Jek Queen King Ace]] 
Joker = Const['Joker']

Card = (Suit * Rank) | Joker # * - creates a tuple, | creates a union 
Hand = List[Card, min_len: 5]
Deck = List[Card, max_len: 54]
Player = Record[name: Str, hand: Hand]

ShuffledDeck = List[Card, max_len: 54]
Shuffle = Deck >> ShuffledDeck

Deal = ShuffledDeck >> (ShuffledDeck * Card)
PickupCard = ((Hand * Card) >> Hand)


Option[Int] # is like Int | Nothing 

# union - one of 
# tuple - all of                    
# Choice is a better choice of 

# Do We Really need null? Null means Something is unknown.

# construct method of the type will return monad! (Success or Failure)
# Validators Has To Return Monads
# Coercers Has To Return Monads

Email = StringValue[pattern: URI::MailTo::EMAIL_REGEXP] do 
  def domain
    value.split('@').last 
  end
  
  def name
    value.split('@').first
  end
end
VerifiedEmail = Email[] 


x = Email.new("john@doe.com")
x.value 
x.to_s # now this is not a email. this is just a string 



class Amount < Record  
  attr_accessor :cents
  attr_types cents: PositiveInt, currency: Currency
  
  def dollars
    cents.value  / 100.0
  end
  
  def to_s
    "#{dollars} #{currency..to_s.upper}"
  end
  
  def +()
    
  end
end

# default value only makes sense for (some) commands

# there will be no nulls => null means value undefined 
# key with null => no key => try to access => exception 
# index with null => no index 

# am = Amount.new(100, "USD")
# am.cents # here i can hide it behind and return value not type  
# am.currency.usd?  

# in responses if a field requested wich user has no access to then it's an error. (Unknown field)
# so instead of "optional" it has to be conditional and only makes sense for responses in queries 
# conditional makes sense only in context of commands and queries 


class Payments < Hexa::Domain
  Person = Record[email: Option[Email]]  # union or choice? choice sounds better

  NULL = Undefined = Optional[]

  CommandHandler = CreateCaseFile * FeeTable * UserName * SomeOtherModel >> List[CaseFileWasCreated]
  CaseFileProjector = CaseFileWasCreated * CaseFile >> ReceivableSide
  UpdateUserParams = Record[first_name: Union[Str, Nothing], last_name: Optional[Str], ]
  UpdateUser = Command * UpdateUserParams


  PatchClaimData = ClaimData.optional
  PatchClaim = Command * PatchClaimData
  MainClaimCreatedEvent = Event[PatchClaimData]

  CaseFileIdParams = Record[case_file_id: CaseFileId]
  Data = Query[CaseFileIdParams, Response]
  Record = AllOf[] + OneOf[]

  Model = Entity[UserId, name: UserName]
  

  PathChaimHandler = Handler[PatchClaim * CaseFile >> List[MainClaimCreatedEvent, MainClaim]]
  StateStoredRepository = Command >> Model
  UserEvents = Event1 | Event2 | Event3 | Event4 | Event5 
  EventSourcingRepository = Command >> List[UserEvents]
  ModelInitialState = Nothing >> Model 
  
  MyQueryHandler = Handler[Query[Request, Response] * Model1 * Model2 >> Stream[Response]] 
  #
  # AllCommands, AllRepositories, All

  # StateStoredRepository.new do  
  EcternalEventHandler = ExternalEven * State >> Command 
  CommandWithoutEventSourcing = Command * State >> State
  RepostoryStateSave = State >> Nothing 
  Repository = Command >> State, State >> Nothing 
  
  #  
  # end
  
  # Record = make one of? Or OneOf[], AllOf - is a record  
  # Record + Record  
  # Record1 + Record2 - Record3 (all of record1 and all of Record2 and one of Record3)   
  # Record1 ^ Record2 - old fields from record 1 or All fields from record 2 
  # Tuple + Tuple 
  # ~Record = make all optional
end


# These gives domain definition, not implementation


# Choice
# 1) Do not allow the same type
# 2) If can't distinguish automatically then request tag 

```




