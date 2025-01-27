# HEXA 

Hexa is a Hexagonal Architecture Framework with element of Functional DDD.
   
Reading List:
* About Hexagonal Architecture and DDD read [here](https://herbertograca.com/2017/11/16/explicit-architecture-01-ddd-hexagonal-onion-clean-cqrs-how-i-put-it-all-together/).
* About Functional DDD [here](https://fraktalio.com/blog/) and [here](https://www.slideshare.net/slideshow/domain-modeling-made-functional-devternity-2022/254826776#1)
     

# Types 

```mermaid
classDiagram
      Type <|-- Nothing 
      Type <|-- Func
      Type <|-- Record
      Type <|-- Choice 
      Type <|-- Tuple
      Type <|-- Union
      Type <|-- Enum
      Type <|-- List
      Type <|-- Map
      Type <|-- Native
      Native <|-- Str
      Native <|-- Number
      Native <|-- BigInt
      Native <|-- Int
      Number <|-- Double
      Native <|-- Real
      Native <|-- Bool
      Native <|-- Date
      Native <|-- Time  
```
## Declaring a type 
* with ```type``` keyword
## Native Types
### Str
### Int
### Real
### Bool
### Date
### Time


## Nothing Type
### Nothing vs. ```nil``` (no nil in managed code!)
## ~~Type keys~~
* ~~Types might have tags~~
* ~~Tag might be used in Records or Choice construction as default key~~
* ~~If (A | Nothing) is used type construction and A has a tag then the tag might be used as a default key~~
* ~~If type has a tag then it might be used as implementation param name~~
## Record Type
### Items 
* all items are types with keys
### Records Constraints 
### Records Composition ```+``` 
## Choice Type
### Records and Choices Composition ```+```
## Union Type
### ```|``` operator 
## Tuple Type
### ```*``` operator
## List Type 
### Items 
### Prefix Items
### Constraints
## Func Type
### ```>>``` operator



## Types operations

```Type1 | Tupe2```  &rarr; ```Union[Type1, Type2]```

```Union[Type1, Tupe2] | Type3```  &rarr; ```Union[Type1, Type2, Type3]```

```Union[Type1, Tupe2] | Union[Type3, Tupe4]```  &rarr; ```Union[Type1, Type2, Type3, Type4]```

```Type1 * Type2```  &rarr; ```Tuple[Type1, Type2]```

```Tuple[Type1, Type2] * Type3```  &rarr; ```Tuple[Type1, Type2, Type3]```

```Tuple[Type1, Type2] * Tuple[Type3, Type4]```  &rarr; ```Tuple[Type1, Type2, Tuple[Type3, Type4]]```

```Tuple[Type1, Type2] & Tuple[Type3, Type4]```  &rarr; ```Tuple[Type1, Type2, Type3, Type4]```

```Record[a:..., b:...] + Record[c:..., d:...]```  &rarr; ```Record[a:..., b:..., c:..., d:....]```

```Choice[a:..., b:...] + Choice[c:..., d:...]```  &rarr; ```Choice[a:..., b:..., c:..., d:....]```

```Record[a:..., b:...] + Choice[c:..., d:...]```  &rarr; ```Union[Record[a:..., b:...,c:...], Record[a:..., b:...,d:...]]```

```Record[a:..., b:...] + Unin[Record[c:...],Record[d:...]]```  &rarr; ```Union[Record[a:..., b:...,c:...], Record[a:..., b:...,d:...]]```


```Func1(...) & Func2(...)```  &rarr; ```Func2(Func1(...))``` this will explicitly create a pipeline

```Type1 >> Type2 ``` &rarr; ```Func[Type1, Type2]```


## Custom Types 
### Native 
```ruby 
class TestType < Hexa::NativeType 
  builder do
    def path(path)
        
    end   
  end
  
  coerce String do
    # ... 
  end
  
  scope_helpers do
    def file
      TestType.prototype 
    end  
  end
end

class MyScope < Hexa::Scope 
  include TestType.scope_helpers 
end 
```

# Scopes  
## Sealing
* ```seal``` will convert all type constance into map { name => type }
* ```seal``` may have a default parameter. if yes then a call method will be defined.

## Initialization 
* ```init``` keyword will create a constant 
* params described in ```init``` will become the Scope class constructor params   

## Functions 
* ```fn``` keyword to define a function 
* Function will explicitly create a pipeline with only one pipe 
* function can be initialized from:
  - __symbol__: local method 
  - __collable__: Anything which has call method 
  - __Block__:
* If function has a parameter with is a constant or a constructor function then it will be automatically curried 

## Constructors 
* A function with no input parameters (Nothing) is a constructor. it will be automatically calculated 

## Constants
* Constants have to be followed by implementation (block) or a constant expression 
* Constants will explicitly create a constructor function
* Constant expression will explicitly create a constructor function

## Annotations 
* Annotation can be added for every type like
```ruby
class UserAccount < Hexa::Domain 
  User = type record name: str, email: str
  
  doc User, "Hello World"
  doc User, :name, "Name"
  doc User, name: "Name", email: "Email" 
  
  doc User do 
    doc :name, "Hello"
    doc :world, "World"
  end
  
  Default = pipeline str >> str do
    pipe :one
    pipe :two
    pipe :three
  end
  
  doc Default do 
    doc "One"
    doc "Two"
    doc "Three"
  end
end

```
* It's better to keep annotations as a separate moule 
```ruby

class UserAccount < Hexa::Domain
  User = type record name: str, email: str

  Default = pipeline str >> str do
    pipe :one
    pipe :two
    pipe :three
  end

  include Implementations
  include Annotations  
  
  seal
end


class UserAccount < Hexa::Domain 
  module Annotations
    extend Hexa::Patial 
    
    included do
      doc :user, "Hello World", name: "Name", email: "Email"
      doc :default, :items, ["One", "Two", "Three"]
    end
  end
end

class UserAccount < Hexa::Domain
  module Implementations
    def one(str)
      "one: #{str}"  
    end
    
    def two
      "two: #{str}"
    end

    def three
      "three: #{str}"
    end
  end
end

```




# Generics

* ```Typ``` for generic parameter
* ```Sub``` for generic parameter substitution

# Monads
## Success (Result)
## Failure
## Skip
## Maybe
## Panic
## IO



# Functional Compositions


# Pipeline
* ```pipeline``` keyword 
## Pipes 
* requires native implementation
  - ~symbol~ means class method. In this case seal  
  - ~block~ block is an implemenation 
* can take as 1-st parameter:
  - function type (has to match previos and next pipe)
  - just output type. (input type will be inferred from the previous pipe output)
  - noting (output type will be the same as input and input will be in inferred from the prev. pipe output)
* first pipe has to be a constructor function (i.e. all it's inputs are curried either from constants, 
  or form constructors, or from pipeline input parameters)
* last pipe output has to match pipeline output type 

## Composers 
### Pipelines inside pipelines 
```ruby
class MyScope < Hexa::Scope
  input = init str * str 
  
  Forward = pipeline str >> str do |inp|
    pipe inp * input >> str, :one # pipe method will create a function with implementation method(:one)
    pipe :two  #input and output type will be inferred automatically  
    pipe :three
    pipe :four  
  end
  
  Backward = pipeline str >> str do |inp|
    pipe inp * input >> str, :four
    pipe :three
    pipe :two
    pipe :one
  end
 
  def one(str, inp)
    str + ":f1[#{inp.join(',')}]"
  end
  
  def two(str, inp)
    str + ":f2[#{inp.join(',')}]"
  end

  def three(str, inp)
    str + ":f3[#{inp.join(',')}]"  
  end
  
  def four(str, inp)
    str + ":f4[#{inp.join(',')}]"
  end
  
  seal Forward # at the moment of export we will check that all implementations are in place 
end

class MyScopeAlternativeSyntax < Hexa::Scope
  input = init str * str
  
  one = fn str * input >> str, :one
  two = fn str * input >> str, :two
  three = fn str * input >> str, :three
  four = fn str * input >> str, :four

  Forward = one & two & three & four

  Backward = one + two + three + four

  def one(str, inp)
    str + ":f1[#{inp.join(',')}]"
  end

  def two(str, inp)
    str + ":f2[#{inp.join(',')}]"
  end

  def three(str, inp)
    str + ":f3[#{inp.join(',')}]"
  end

  def four(str, inp)
    str + ":f4[#{inp.join(',')}]"
  end
  
  Default = Forward

  seal  # at the moment of export we will check that all implementations are in place 
end

test = MyScope.new('aaa', 'bbb')

test.forward # return result, nil if nothing,  and exception on error 
test.backward

test.call(:forward) # returns monadic value 
test.call(:backward)

test.to_proc(:forward)  # returns result and exception if not result 
test.to_proc(:backward)

test.to_proc(:forward, false)  # returns monadic value 
test.to_proc(:backward, false)  

```


MyPackage::HelloWorld.call


### All Of, Some Of, One Of, Any Of  
Result a Tuple (for tuple input) or a Record (for record input)

```ruby
  pipeline str >> str do |str|
    split do
      pipe str >> maybe(Event1), :native_impl_1 # here can be eiter function of func type + native implementation 
      pipe str >> maybe(Event2), :native_impl_2
      pipe str >> maybe(Event3), :native_impl_3
      pipe str >> maybe(Event4), :native_impl_4
    end
    # result is a tuple of monads

    join  # options: all_or_error, all_or_error
  end 
```

```ruby
class UserAccount < Hexa::Domain 
  user_data = type record first_name: str, last_name: str

  CreateUser = type command + user_data # + means that command will concatenate all attributes from the record 
  
  UserId = type str 
  
  UserAggregate = type aggregate UserId # aggegate takes an id type as a parameter
      
  User = type entity(UserAggregate) + user_data # if entity takes an aggreagte as a key, then it becomes an aggregate 
                                                # root entity. each command has to have at least on aggregate root   
  Account = type entity UserAggregate, balance: int
  Order = type entity UserAggregate, date: date, amount: int

  AccWasCreaded = type event.wip
  AccWasFunded = type event.wip
  AccWasWithdrawn = type event.wip
   
  AccountEvents = type AccWasCreaded | AccWasFunded | AccWasWithdrawn
   
  Ports = init record get_user: UserId >> io(User),
                      put_user: User >> io,
                      get_account_events: UserId >> io(AccountEvents.list),
                      put_account_events: AccountEvents >> io,
                      get_order: UserId >> io(Order),
                      put_order: Order >> io,
                      user_id_provider: Nothing >> io(str)
   
  repository Ports[:get_user], Ports[:put_user], Ports[:get_account_events], Ports[:put_account_events],
             Ports[:get_order], Ports[:put_order] # this will generate a func with a native implementation aka proc 

  UserEvents = type Event1 | Event2 | Event3 | Event4

  # decider builder 
  decide CreateUser * Ports[:user_id_provider] >> result(UserEvents) do |command, id_provider| 
    # we are inside pipeline. after params substitution the 1-st step of th pipeline always starts with Nothing.
    pipe id_provider >> str, &:call
    split do
      pipe command * id >> maybe(Event1), :native_impl_1
      pipe command * id >> maybe(Event2), :native_impl_2 
      pipe command * id >> maybe(Event3), :native_impl_3
      pipe command * id >> maybe(Event4), :native_impl_4
    end
    join # convert tuple to a list?
  end
 
  evolve Account * AccBalanceWasUpdated >> Account do |account, event|
    pipe account * event >> Account do |account, event|
      account.mutate { |x| x.balance = event.balance }
    end
  end
  
  seal # export here is overloaded. it will  
end
```
### Pipeline blocks
* Split
* Join 

### Any Of 
Result is a Union  (for tuple input) or a Choice (for record input)
If all have the same type then output will be this type without union

### Join

### Repeater - Until
### Repeater - While


## ConnectionExit
### Bind
### Map
### Tee
### Buffering 
### Generators
Repeater + Buffering?


## Error Handling 
### Panics vs Failures 
### Deferred 
### Compensate
Any Of 
  - Branch : x -> Maybe[y]
  - Compensate : x -> Success[y] (returns success only)



```ruby
class Accounting < Hexa::Domain 
  Cents = type int.wip 
  
  MainClaim = type record.wip
  
  SideClaim = type record.wip 
  
  CreditorBounce = type record.wip
  
  CreditorPayment = type record.wip
  
  CreditorClaim = type record main_claim: MainClaim,  side_claims: SideClaim.list, 
                              bounces: CreditorBounce.list, payments: CreditorPayment.list
  
  CollectionFee = type record.wip

  CollectionPayment = type record.wip

  CaseFile = type record claims: CreditorClaim.list, fees: CollectionFee.list, payments: CollectionPayment.list
end
```


* Type keyword seals the type
* Type keyword just copies everithin which the variable has at the moment to a new type variable
* Only sealed type can be used in function, choices, tupes, lists, maps, etc  
* Type which defines constrains is a prototype. Special keyword for a prototype?


### Example!

Putting external parameters to validators 

```ruby 
class InstallmetnPlans < Hexa::Domain
  currency = type enum(:usd, :eur, :chf)
  input = init record supported_currencies: currency.list, current_date: date 
  
  earliest_date = const input[:current_date]

  latest_date = fn input >> date { |x| x[:current_date] + 1.day }
  
  supported_currencies = fn input >> currency.list { |x| x[:supported_currencies] } 
  
  CaseFileId = type str.wip
  
  Cents = type int gt: 100
  Currency = type enum supported_currencies # enum can take a const list 
  Amount = type record cents: Cents, currency: Currency

  CreateInstallmentPlan = type command case_file_od: CaseFileId, 
                                       amount: Amount, 
                                       start_date: date(gt: earliest_date, lte: latest_date)
  
  InstallmetnPlanWasCreated = event.wip
  
  decide CreateInstallmentPlan >> InstallmetnPlanWasCreated.list do |command|
    # ... 
  end
  
  seal   
end 

ip_scope =  InstallmetnPlans.new(%w[usd eur], Date.today)
```




